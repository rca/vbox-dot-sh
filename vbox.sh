VBOX_MANAGE='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage-amd64'

function vautostart() {
    cat ${HOME}/.vbox_autostart | while read i; do
        ${VBOX_MANAGE} startvm --type=headless $i
    done;
}

function _vdo() {
    buf=$1
    shift;

    while [ ! -z $1 ]; do
      `printf "${VBOX_MANAGE} ${buf}" "$1";`
      shift;
    done;
}

function _vinfo() {
    while read name uuid; do
        name=$(echo ${name} | sed -e 's/"//g')
        echo "${name} ${uuid} $(vmac ${name})"
    done;
}

function vmac() {
    macs=()

    for mac in $(${VBOX_MANAGE} showvminfo "$@" | grep NIC | grep MAC | sed 's/.*MAC: \([^,]*\).*/\1/'); do
        macs+=($(echo ${mac} | sed -e 's/\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)/\1:\2:\3:\4:\5:\6/'))
    done;

    echo ${macs[@]}
}

function vstart() {
    _vdo "startvm --type=headless %s" "$@"
}

function vlist() {
    ${VBOX_MANAGE} list vms | _vinfo
}

function vpause() {
    _vdo "controlvm %s pause" "$@"
}

function vresume() {
    _vdo "controlvm %s resume" "$@"
}

function vreset() {
    _vdo "controlvm %s reset" "$@"
}

function vrunning() {
    ${VBOX_MANAGE} list runningvms | _vinfo
}

function vpoweroff() {
    _vdo "controlvm %s poweroff" "$@"
}

function vsavestate() {
    _vdo "controlvm %s savestate" "$@"
}

function vacpipowerbutton() {
    _vdo "controlvm %s acpipowerbutton" "$@"
}
