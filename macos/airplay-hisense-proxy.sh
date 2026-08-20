#!/bin/zsh
# ==========================
# AirPlay Bonjour Proxy — Hisense VIDAA TV
# ==========================
# Author: vb
# Description: Makes a Hisense VIDAA TV appear in macOS Screen Mirroring when
#              the Wi-Fi network drops mDNS/Bonjour multicast (224.0.0.251).
#
# WHY THIS EXISTS
#   The TV's AirPlay 2 receiver is healthy and reachable by unicast TCP on
#   port 7000, but its mDNS announcement never reaches the Mac, so macOS
#   never lists it. Instead of fixing the network, we ask the TV directly for
#   the TXT record it *would* advertise (GET /info?txtAirPlay) and register
#   that record locally with `dns-sd -P`. macOS then discovers the TV without
#   any multicast involved.
#
#   The TXT is fetched live every run on purpose: deviceid, pk, psi and gid
#   rotate. Never hardcode them.
#
# USAGE
#   ./airplay-hisense-proxy.sh [start|stop|status|diag|install-agent|uninstall-agent] [TV_IP]
# ==========================

set -u

AIRPLAY_PORT=7000
PROXY_HOST="hisense-airplay.local"
CACHE="$HOME/.cache/airplay-hisense-ip"
LOG="$HOME/Library/Logs/airplay-hisense-proxy.log"
PLIST_LABEL="com.vb.airplay-hisense-proxy"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_LABEL.plist"
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

mkdir -p "$(dirname "$CACHE")" "$(dirname "$LOG")"

# ==========================
# 1. Locate the TV
# ==========================
# A Hisense VIDAA TV drops ICMP and most TCP ports, so we cannot ping-sweep.
# We probe port 7000 and confirm identity via the AirPlay /info plist.
is_hisense_airplay() {
    local ip="$1"
    nc -z -G 2 "$ip" "$AIRPLAY_PORT" 2>/dev/null || return 1
    curl -s --max-time 5 "http://$ip:$AIRPLAY_PORT/info" 2>/dev/null \
        | strings | grep -qiE 'hisense|vidaa|AirTunes'
}

find_tv() {
    # 1) explicit argument
    if [ -n "${1:-}" ]; then
        if is_hisense_airplay "$1"; then echo "$1"; return 0; fi
        echo "❌ $1 não responde como receiver AirPlay Hisense" >&2
        return 1
    fi

    # 2) last known good
    if [ -f "$CACHE" ]; then
        local cached; cached="$(cat "$CACHE")"
        if [ -n "$cached" ] && is_hisense_airplay "$cached"; then echo "$cached"; return 0; fi
    fi

    # 3) scan the local subnet
    echo "🔍 Procurando a TV na rede local..." >&2
    local bcast; bcast="$(ifconfig en0 | awk '/broadcast/{print $6}')"
    [ -n "$bcast" ] && ping -c 2 -t 1 "$bcast" >/dev/null 2>&1   # seed the ARP table

    local -a candidates
    candidates=($(arp -an | grep -oE '\(192\.168\.[0-9]+\.[0-9]+\)' | tr -d '()' | sort -u))

    local ip
    for ip in $candidates; do
        if is_hisense_airplay "$ip"; then echo "$ip"; return 0; fi
    done

    echo "❌ Nenhum receiver AirPlay Hisense encontrado. Passe o IP: $SELF start 192.168.1.73" >&2
    return 1
}

# ==========================
# 2. Fetch the genuine TXT record from the TV
# ==========================
# GET /info?txtAirPlay returns the real advertisement blob, including `pk`
# (Ed25519 public key) which macOS requires to pair. Plain /info omits it.
fetch_txt() {
    local ip="$1" tmp
    tmp="$(mktemp -t airplay-txt)"
    curl -s -g --max-time 8 -o "$tmp" \
        -H 'User-Agent: AirPlay/665.13.1' \
        "http://$ip:$AIRPLAY_PORT/info?txtAirPlay&txtRAOP" || { rm -f "$tmp"; return 1; }

    python3 - "$tmp" <<'PYEOF'
import plistlib, sys
data = plistlib.loads(open(sys.argv[1], 'rb').read())
blob = next((bytes(v) for k, v in data.items() if k.lower().startswith('txtairplay')), None)
if not blob:
    sys.exit(1)
i = 0
while i < len(blob):                      # DNS-SD TXT: length-prefixed strings
    n = blob[i]; i += 1
    if n == 0 or i + n > len(blob):
        break
    print(blob[i:i+n].decode('utf-8', 'replace'))
    i += n
PYEOF
    local rc=$?
    rm -f "$tmp"
    return $rc
}

# Instance name shown in the Screen Mirroring menu
tv_name() {
    curl -s --max-time 5 "http://$1:$AIRPLAY_PORT/info" 2>/dev/null \
        | plutil -convert xml1 -o - - 2>/dev/null \
        | grep -A1 '<key>name</key>' | tail -1 \
        | sed -e 's/.*<string>//' -e 's|</string>.*||'
}

# ==========================
# 3. Commands
# ==========================
cmd_stop() {
    if pgrep -f "dns-sd -P .*_airplay._tcp" >/dev/null 2>&1; then
        pkill -f "dns-sd -P .*_airplay._tcp"
        echo "🛑 Proxy AirPlay parado"
    else
        echo "ℹ️  Nenhum proxy rodando"
    fi
}

cmd_start() {
    local ip name
    ip="$(find_tv "${1:-}")" || return 1
    echo "$ip" > "$CACHE"
    echo "📺 TV encontrada em $ip"

    local -a txt
    txt=($(fetch_txt "$ip")) || { echo "❌ Falha ao obter o TXT record da TV"; return 1; }
    if [ ${#txt[@]} -eq 0 ]; then
        echo "❌ TXT record vazio — a TV recusou /info?txtAirPlay"
        return 1
    fi
    echo "🔑 TXT record obtido da própria TV (${#txt[@]} campos)"
    printf '%s\n' $txt | grep -E '^(deviceid|pk|model|srcvers)=' | sed 's/^/     /'

    name="$(tv_name "$ip")"; [ -z "$name" ] && name="Hisense VIDAA TV"

    cmd_stop >/dev/null 2>&1
    nohup dns-sd -P "$name" _airplay._tcp local "$AIRPLAY_PORT" \
        "$PROXY_HOST" "$ip" $txt >>"$LOG" 2>&1 </dev/null &
    disown

    sleep 2
    if pgrep -f "dns-sd -P .*_airplay._tcp" >/dev/null 2>&1; then
        echo "✅ Proxy ativo: \"$name\" → $ip:$AIRPLAY_PORT"
        echo ""
        echo "📋 Agora abra: Control Center → Screen Mirroring"
        echo "   Para parar:  $SELF stop"
        echo "   Log:         $LOG"
    else
        echo "❌ O proxy morreu ao iniciar. Veja $LOG"
        return 1
    fi
}

cmd_status() {
    if pgrep -f "dns-sd -P .*_airplay._tcp" >/dev/null 2>&1; then
        echo "✅ Proxy rodando (pid $(pgrep -f 'dns-sd -P .*_airplay._tcp' | tr '\n' ' '))"
    else
        echo "🛑 Proxy parado"
    fi
    echo ""
    echo "🔍 Instâncias _airplay._tcp visíveis em en0:"
    local out; out="$(mktemp -t airplay-browse)"
    dns-sd -B _airplay._tcp local >"$out" 2>&1 & local bp=$!
    sleep 5; kill $bp 2>/dev/null; wait $bp 2>/dev/null
    tail -n +5 "$out" | sed 's/^/   /' | head; rm -f "$out"
}

# ==========================
# 4. Root-cause diagnostic (needs sudo — BPF is root-only on macOS)
# ==========================
cmd_diag() {
    local cap; cap="$(mktemp -t mdns-cap)"
    echo "🛑 Parando o proxy para uma captura limpa..."
    cmd_stop >/dev/null 2>&1; sleep 1

    echo "🎧 Capturando 30s de UDP/5353 em en0 (o sudo vai pedir a senha)..."
    sudo tcpdump -n -i en0 -l 'udp port 5353' >"$cap" 2>/dev/null & local tp=$!
    sleep 2
    dns-sd -B _airplay._tcp local >/dev/null 2>&1 & local b1=$!
    dns-sd -B _raop._tcp    local >/dev/null 2>&1 & local b2=$!
    echo "👉 ABRA AGORA o Control Center → Screen Mirroring"
    sleep 28
    kill $b1 $b2 2>/dev/null; sudo kill $tp 2>/dev/null; sleep 1

    local me out in tv
    me="$(ipconfig getifaddr en0)"
    out=$(grep -c "$me\.5353 >" "$cap")
    in=$(grep '\.5353' "$cap" | grep -vc "$me\.5353 >")
    tv=$(grep -c "$(cat "$CACHE" 2>/dev/null || echo 0.0.0.0)\.5353" "$cap")

    echo ""
    echo "=========== RESULTADO ==========="
    echo "saindo do Mac ($me) : $out"
    echo "entrando de outros  : $in"
    echo "vindo da TV         : $tv"
    echo ""
    echo "IPs distintos em 5353:"; grep -oE '192\.168\.[0-9]+\.[0-9]+\.5353' "$cap" | sort -u | sed 's/^/   /'
    echo ""
    if   [ "$out" -eq 0 ]; then
        echo "🔴 O Mac NÃO transmite mDNS → mDNSResponder quebrado."
        echo "   Suspeito: Internet Sharing. Ação: sudo killall -HUP mDNSResponder"
    elif [ "$in" -eq 0 ]; then
        echo "🔴 Queries saem, nada entra → o ROUTER está dropando multicast."
        echo "   Ação: desligar IGMP Snooping / ligar Multicast Forwarding no router."
    elif [ "$tv" -eq 0 ]; then
        echo "🔴 Outros hosts chegam, a TV nunca fala → responder mDNS da TV travado."
        echo "   Ação: tirar a TV da tomada por 60s (desligar no controle não basta)."
    else
        echo "🔴 Pacotes da TV chegam mas o dns-sd não os mostra → mDNSResponder descarta."
        echo "   Suspeito: Internet Sharing. Ação: sudo killall -HUP mDNSResponder"
    fi
    echo "================================="
    echo "captura crua: $cap"
}

# ==========================
# 5. Persistence across reboot (opt-in)
# ==========================
cmd_install_agent() {
    cat > "$PLIST_PATH" <<PEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>$PLIST_LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/zsh</string>
        <string>$SELF</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><false/>
    <key>StandardOutPath</key><string>$LOG</string>
    <key>StandardErrorPath</key><string>$LOG</string>
</dict>
</plist>
PEOF
    launchctl unload "$PLIST_PATH" 2>/dev/null
    launchctl load "$PLIST_PATH" && echo "✅ LaunchAgent instalado: sobe no login ($PLIST_PATH)"
}

cmd_uninstall_agent() {
    launchctl unload "$PLIST_PATH" 2>/dev/null
    rm -f "$PLIST_PATH" && echo "🗑️  LaunchAgent removido"
}

# ==========================
# 6. Dispatch
# ==========================
case "${1:-start}" in
    start)           cmd_start "${2:-}" ;;
    stop)            cmd_stop ;;
    status)          cmd_status ;;
    diag)            cmd_diag ;;
    install-agent)   cmd_install_agent ;;
    uninstall-agent) cmd_uninstall_agent ;;
    *) echo "uso: $0 [start|stop|status|diag|install-agent|uninstall-agent] [TV_IP]"; exit 1 ;;
esac
