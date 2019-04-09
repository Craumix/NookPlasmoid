import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.8
import QtQml 2.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import Qt.labs.settings 1.0


Rectangle {
    id: rect
    width: 250
    height: control.height + time_label.height + play.height + 30
    color: "#31363b"
    border.width: 0

    property bool playing: false

    Settings {
        property alias volume: volumeSlider.value
        property alias playing: rect.playing
        property alias gameindex: control.currentIndex
    }

    Image {
        id: background
        width: parent.width
        height: parent.height
    }

    Text {
        id: time_label
        font.family: "Helvetica"
        color: "#ffffff"
        font.pointSize: 16
        text: "Time: " + rect.getTime()
    }

    ComboBox {
        id: control
        y: time_label.height + 10
        width: 250
        model: [
            "AC: Population Growing (GC)",
            "AC: Wild World / City Folk (DS)",
            "AC: Wild World / City Folk (DS) [Rainy]",
            "AC: Wild World / City Folk (DS) [Snowy]",
            "AC: New Leaf (3DS)",
            "AC: New Leaf (3DS) [Rainy]",
            "AC: New Leaf (3DS) [Snowy]"]
    }

    Button {
        id: play
        y: time_label.height + control.height + 20
        width: 50
        height: 50
        onClicked: rect.playClicked()

        PlasmaCore.IconItem {
            id: play_icon
            width: parent.width
            height: parent.height
            source: rect.getPlayIconState()
        }
    }

    Text {
        id: vol_text
        y: time_label.height + control.height + 20
        x: play.width + 10
        height: 25
        color: "#ffffff"
        text: "Volume: " + volumeSlider.vol_percent
    }

    Slider {
        id: volumeSlider
        y: time_label.height + control.height + 40
        x: play.width + 10
        height: 25
        width: rect.width - play.width - 10
        value: 0.25

        property real volume: QtMultimedia.convertVolume(volumeSlider.value,
                                                     QtMultimedia.LogarithmicVolumeScale,
                                                     QtMultimedia.LinearVolumeScale)

        property string vol_percent: Math.round((value * 100)).toString() + "%"
    }

    Audio {
        id: player
        loops: Audio.Infinite
        volume: volumeSlider.volume
        source: getFilename()
    }

    Timer {
        id: timer
        interval: 500
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            if(rect.playing && play.source != getFilename()) {
               rect.updateAndPlay()
               time_label.text =  "Time: " + rect.getTime()
            }
        }
    }

    function updateAndPlay() {
        player.source = getFilename()
        player.play()
    }

    function playClicked() {
        rect.playing = !rect.playing
        play_icon.source = getPlayIconState()
        if(rect.playing) {
            rect.updateAndPlay()
        }else {
            player.pause()
        }
    }

    function getTime() {
        return new Date().toLocaleString(Qt.locale(), "hAP").toLowerCase()
    }

    function getGameName() {
        switch(control.currentIndex) {
        case 0: return "population-growing";
        case 1: return "wild-world";
        case 2: return "wild-world-rainy";
        case 3: return "wild-world-snowy";
        case 4: return "new-leaf";
        case 5: return "new-leaf-rainy";
        case 6: return "new-leaf-snowy";
        default:return "wild-world";
        }
    }

    function getFilename() {
        return "../sound/" + getGameName() + "/" + getTime() + ".ogg"
    }

    function getPlayIconState() {
        if(!rect.playing) {
            return "media-playback-start"
        }else {
            return "media-playback-pause"
        }
    }
}