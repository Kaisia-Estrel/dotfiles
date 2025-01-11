import QtQuick 2.15
import QtQuick.Controls 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480
    color: config.stringValue("backgroundFill") || "transparent"

    readonly property color textColor: config.stringValue("basicTextColor")
    property int currentUsersIndex: userModel.lastIndex
    property int currentSessionsIndex: sessionModel.lastIndex
    property int usernameRole: Qt.UserRole + 1
    property int realNameRole: Qt.UserRole + 2
    property int sessionNameRole: Qt.UserRole + 4
    property string currentUsername: config.boolValue("showUserRealNameByDefault") ? userModel.data(userModel.index(currentUsersIndex, 0), realNameRole) : userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)
    property string currentSession: sessionModel.data(sessionModel.index(currentSessionsIndex, 0), sessionNameRole)
    property string passwordFontSize: config.intValue("passwordFontSize") || 96
    property string usersFontSize: config.intValue("usersFontSize") || 48
    property string sessionsFontSize: config.intValue("sessionsFontSize") || 24

    function usersCycleSelectPrev() {
        if (currentUsersIndex - 1 < 0) {
            currentUsersIndex = userModel.count - 1;
        } else {
            currentUsersIndex--;
        }
    }

    function usersCycleSelectNext() {
        if (currentUsersIndex >= userModel.count - 1) {
            currentUsersIndex = 0;
        } else {
            currentUsersIndex++;
        }
    }

    function bgFillMode() {
        switch (config.stringValue("backgroundMode")) {
        case "aspect":
            return Image.PreserveAspectCrop;
        case "fill":
            return Image.Stretch;
        case "tile":
            return Image.Tile;
        default:
            return Image.Pad;
        }
    }

    function sessionsCycleSelectPrev() {
        if (currentSessionsIndex - 1 < 0) {
            currentSessionsIndex = sessionModel.rowCount() - 1;
        } else {
            currentSessionsIndex--;
        }
    }

    function sessionsCycleSelectNext() {
        if (currentSessionsIndex >= sessionModel.rowCount() - 1) {
            currentSessionsIndex = 0;
        } else {
            currentSessionsIndex++;
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            backgroundBorder.border.width = 5;
            passwordBg.border.width = 10;
            animateBorder.restart();
            passwordInput.clear();
        }
        function onLoginSucceeded() {
            backgroundBorder.border.width = 0;
            passwordBg.border.width = 0;
            animateBorder.stop();
        }
    }

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height
        Shortcut {
            sequences: ["Alt+U", "F2"]
            onActivated: {
                if (!username.visible) {
                    username.visible = true;
                    return;
                }
                usersCycleSelectNext();
            }
        }
        Shortcut {
            sequences: ["Alt+Ctrl+S", "Ctrl+F3"]
            onActivated: {
                if (!sessionName.visible) {
                    sessionName.visible = true;
                    return;
                }
                sessionsCycleSelectPrev();
            }
        }

        Shortcut {
            sequences: ["Alt+S", "F3"]
            onActivated: {
                if (!sessionName.visible) {
                    sessionName.visible = true;
                    return;
                }
                sessionsCycleSelectNext();
            }
        }
        Shortcut {
            sequences: ["Alt+Ctrl+U", "Ctrl+F2"]
            onActivated: {
                if (!username.visible) {
                    username.visible = true;
                    return;
                }
                usersCycleSelectPrev();
            }
        }

        Shortcut {
            sequence: "F10"
            onActivated: {
                if (sddm.canSuspend) {
                    sddm.suspend();
                }
            }
        }
        Shortcut {
            sequence: "F11"
            onActivated: {
                if (sddm.canPowerOff) {
                    sddm.powerOff();
                }
            }
        }
        Shortcut {
            sequence: "F12"
            onActivated: {
                if (sddm.canReboot) {
                    sddm.reboot();
                }
            }
        }

        Shortcut {
            sequence: "F1"
            onActivated: {
                helpMessage.visible = !helpMessage.visible;
                hint.visible = !hint.visible;
            }
        }

        Rectangle {
            id: background
            visible: true
            anchors.fill: parent
            NumberAnimation on anchors.leftMargin {
                from: 1300
                to: 0
                duration: 1000
                easing.type: Easing.OutQuad
            }
            NumberAnimation on anchors.rightMargin {
                from: 1300
                to: 0
                duration: 1000
                easing.type: Easing.OutQuad
            }
            color: config.stringValue("backgroundFill") || "transparent"
            Rectangle {
                color: "#181825"
                anchors.fill: parent
                NumberAnimation on anchors.bottomMargin {
                    from: 1000
                    to: 0
                    duration: 1000
                    easing.type: Easing.OutExpo
                }
                Image {
                    id: image
                    anchors {
                        fill: parent
                        bottomMargin: 500
                    }
                    source: config.stringValue("background")
                    smooth: true
                    fillMode: bgFillMode()
                    z: 2
                }
            }

            Rectangle {
                id: backgroundBorder
                anchors.fill: parent
                z: 4
                border.color: "#f38ba8"
                border.width: 0
                color: "transparent"
                Behavior on border.width {
                    SequentialAnimation {
                        id: animateBorder
                        running: false
                        loops: Animation.Infinite
                        NumberAnimation {
                            from: 5
                            to: 10
                            duration: 700
                        }
                        NumberAnimation {
                            from: 10
                            to: 5
                            duration: 400
                        }
                    }
                }
            }
        }

        TextInput {
            id: passwordInput
            Text {
                id: placeholderLock
                text: ""
                font.family: "JetBrainsMono Nerd Font"
                color: "#45475a"
                NumberAnimation on font.pointSize {
                    from: 0
                    to: passwordFontSize / 2
                    duration: 300
                }

                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
              }

            topPadding: 20
            width: passwordFontSize * 2
            Behavior on width {
                NumberAnimation {
                    duration: 100
                    easing: Easing.InExpo
                }
            }

            onTextEdited: function() {
                if (passwordInput.cursorPosition >= passwordInput.length) {
                  textFaderAnim.restart();
                }
                passwordBg.border.width = 0;
                if (passwordInput.length > 0) {
                    placeholderLock.visible = false;
                    passwordCursor.visible = true;
                    passwordInput.width = (passwordInput.length + 1) * passwordFontSize;
                    sessionName.visible = false;
                    username.visible = false;
                    textFader.visible = true;
                } else {
                    passwordCursor.visible = false;
                    placeholderLock.visible = true;
                    textFader.visible = false;
                    passwordInput.width = passwordFontSize * 2;
                }
            }

            height: 200 / 96 * passwordFontSize
            font.pointSize: passwordFontSize
            font.bold: true
            font.letterSpacing: 20 / 96 * passwordFontSize
            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 100
                horizontalCenter: parent.horizontalCenter
            }

            echoMode: config.boolValue("passwordMask") ? TextInput.Password : null
            color: config.stringValue("passwordTextColor") || textColor
            selectionColor: textColor
            selectedTextColor: "#000000"
            clip: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            passwordCharacter: config.stringValue("passwordCharacter") || "*"
            onAccepted: {
                if (text != "" || config.boolValue("passwordAllowEmpty")) {
                    sddm.login(userModel.data(userModel.index(currentUsersIndex, 0), usernameRole) || "123test", text, currentSessionsIndex);
                }
            }
            Rectangle {
              id: textFader
              color: config.stringValue("passwordInputBackground") 
              width: passwordFontSize * 0.8
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenterOffset: (passwordInput.cursorPosition * passwordFontSize * 0.815) 
                - (passwordInput.contentWidth / 2) 
                - (passwordFontSize / 2)
              height: passwordInput.height / 1.5
              opacity: 0
              NumberAnimation on opacity {
                id: textFaderAnim
                from: 1
                to: 0
                duration: 600
                running: false
                easing: Easing.OutExpo
              }
            }

            Rectangle {
                id: passwordCursor
                color: "#C6D3EF"
                visible: false
                width: 30 / 96 * passwordFontSize
                height: passwordInput.height / 1.5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenterOffset: (passwordInput.cursorPosition * passwordFontSize * 0.815) - (passwordInput.contentWidth / 2) 
                  + (width - (30 / 96 * passwordFontSize))/2
                onXChanged: function() {
                  opacity = 1;
                  cursorBlink.restart();
                  if (passwordInput.cursorPosition < passwordInput.length) {
                    width = 12 / 96 * passwordFontSize;
                  } else {
                    width = 30 / 96 * passwordFontSize;
                  }
                }
                Behavior on anchors.horizontalCenterOffset {
                  NumberAnimation {
                    duration: 100
                    easing: Easing.OutExpo
                  }
                }
                Behavior on width {
                  NumberAnimation {
                    duration: 30
                    easing: Easing.OutExpo
                  }
                }
                SequentialAnimation on opacity {
                    id: cursorBlink
                    loops: Animation.Infinite
                    PauseAnimation {
                        duration: 600
                    }
                    NumberAnimation {
                        from: 1
                        to: 0
                        duration: 200
                    }
                    PauseAnimation {
                        duration: 300
                    }
                    NumberAnimation {
                        from: 0
                        to: 1
                        duration: 200
                    }
                    PauseAnimation {
                        duration: 200
                    }
                    running: true
                }
            }
            Rectangle {
                id: passwordBg
                Behavior on border.width {
                    NumberAnimation {
                        duration: 100
                        easing: Easing.InOutCubic
                    }
                }
                z: -1
                border.width: 0
                border.color: "#f38ba8"
                anchors.fill: parent
                anchors.leftMargin: 100
                color: config.stringValue("passwordInputBackground") || "transparent"
                radius: config.intValue("passwordInputRadius") || 10

                NumberAnimation on anchors.leftMargin {
                    from: 100
                    to: 0
                    duration: 500
                    easing.type: Easing.OutQuad
                }

                NumberAnimation on anchors.rightMargin {
                    from: 100
                    to: 0
                    duration: 500
                    easing.type: Easing.OutQuad
                }
                NumberAnimation on opacity {
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
            cursorVisible: false
            cursorDelegate: Rectangle {
                id: passwordInputCursor
                visible: false
                width: 16 / 96 * passwordFontSize
                onHeightChanged: height = passwordInput.height / 1.5
                onXChanged: function() {
                  opacity = 1;
                  cursorBlink.restart()
                }

                anchors.verticalCenter: parent.verticalCenter
                color: config.stringValue("passwordCursorColor") 

                NumberAnimation on x {
                  from: 0
                  to: 2000
                  duration: 300
                }

            }
        }
        UsersChoose {
            id: username
            text: currentUsername
            visible: config.boolValue("showUsersByDefault")
            width: mainFrame.width / 2.5 / 48 * usersFontSize
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: passwordInput.top
                bottomMargin: 40
            }
            onPrevClicked: {
                usersCycleSelectPrev();
            }
            onNextClicked: {
                usersCycleSelectNext();
            }
        }

        SessionsChoose {
            id: sessionName
            text: currentSession
            visible: config.boolValue("showSessionsByDefault")
            width: mainFrame.width / 2.5 / 24 * sessionsFontSize
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 30
            }
            onPrevClicked: {
                sessionsCycleSelectPrev();
            }
            onNextClicked: {
                sessionsCycleSelectNext();
            }
        }

        Text {
            id: hint
            visible: true
            color: "#313244"
            font.pointSize: 12
            font.family: "monospace"
            text: "F1 - Help"
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 50
            }
        }

        Text {
            id: helpMessage
            visible: false
            text: "Show help - F1\n" + "Cycle select next user - F2 or Alt+u\n" + "Cycle select previous user - Ctrl+F2 or Alt+Ctrl+u\n" + "Cycle select next session - F3 or Alt+s\n" + "Cycle select previous session - Ctrl+F3 or Alt+Ctrl+s\n" + "Suspend - F10\n" + "Poweroff - F11\n" + "Reboot - F12"
            color: textColor
            font.pointSize: 18
            font.family: "monospace"
            anchors {
                top: parent.top
                topMargin: 30
                left: parent.left
                leftMargin: 30
            }
        }

        Component.onCompleted: {
            passwordInput.forceActiveFocus();
        }
    }

    Loader {
        active: config.boolValue("hideCursor") || false
        anchors.fill: parent
        sourceComponent: MouseArea {
            enabled: false
            cursorShape: Qt.BlankCursor
        }
    }
}
