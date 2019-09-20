import QtQuick 2.12
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.12

Rectangle {
    readonly property int c_container_min_width: 480;
    readonly property int c_container_min_height: 240;
    readonly property int c_container_max_width: 1000;
    readonly property int c_container_max_height: 500;

    property int g_max_width: 0;
    property int g_max_height: 0;
    property var frameList: [];
    property int frameInterval: 40;
    property bool loop: true;
    property bool playing: false;

    anchors.fill: parent;
    color: "#F5F5F5";

    /* 图片帧 */
    Item {
        id: container_frame;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.topMargin: 5;
        width: {
            var w = image_frame.width;
            if (w < c_container_min_width) {
                w = c_container_min_width;
            } else if (w > c_container_max_width) {
                w = c_container_max_width;
            }
            return w + 1;
        }
        height: {
            var h = image_frame.height;
            if (h < c_container_min_height) {
                h = c_container_min_height;
            } else if (h > c_container_max_height) {
                h = c_container_max_height;
            }
            return h + 1;
        }

        Rectangle {
            anchors.centerIn: parent;
            width: image_frame.width + 1;
            height: image_frame.height + 1;
            border.color: "grey";

            Image {
                id: image_frame;
                anchors.centerIn: parent;

                function change() {
                    if (0 === frameList.length || slider_progress.value >= frameList.length) {
                        source = "";
                        return;
                    }
                    source = frameList[slider_progress.value];
                }
            }

            Timer {
                interval: frameInterval;
                repeat: true;
                running: true;
                onTriggered: {
                    if (playing && frameList.length > 1) {
                        if (slider_progress.value >= frameList.length - 1) {
                            slider_progress.value = 0;
                        } else {
                            ++slider_progress.value;
                        }
                        image_frame.change();
                        if (slider_progress.value >= frameList.length - 1) {
                            if (!loop) {
                                playing = false;
                            }
                        }
                    }
                }
            }
        }
    }

    /* 进度条 */
    Slider {
        id: slider_progress;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: container_frame.bottom;
        anchors.topMargin: 10;
        width: container_frame.width;
        height: 25;
        from: 0;
        to: 0 === frameList.length ? 0 : frameList.length - 1;
        value: 1;
        stepSize: 1;
        ToolTip.visible: hovered;
        ToolTip.text: "拖动滑块改变播放进度, 当前第" + (0 === frameList.length ? 0 : value + 1) + "帧";
        onValueChanged: {
            image_frame.change();
        }
    }

    /* 当前帧名 */
    Text {
        id: text_frame_name;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: slider_progress.bottom;
        anchors.topMargin: 10;
        verticalAlignment: Text.AlignVCenter;
        wrapMode: Text.Wrap;
        clip: true;
        width: container_frame.width;
        height: 0 === frameList.length ? 0 : (1 === lineCount ? 25 : (lineCount * 18));
        text: 0 === frameList.length ? "" : frameList[slider_progress.value];
        font.pixelSize: 16;
    }

    /* 当前帧/总帧数 */
    Text {
        id: text_progress;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: 5;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        clip: true;
        width: 60;
        height: 25;
        text: (0 === frameList.length ? 0 : slider_progress.value + 1) + "/" + frameList.length;
        font.pixelSize: 16;
    }

    /* 播放/暂停按钮 */
    Button {
        id: btn_play_pause;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_stop.left;
        anchors.rightMargin: btn_open.anchors.rightMargin;
        width: 35;
        height: text_progress.height;
        onClicked: {
            if (frameList.length <= 1) {
                return;
            }
            playing = !playing;
            if (playing && slider_progress.value >= frameList.length - 1) {
                slider_progress.value = 0;
            }
        }
        ToolTip.visible: hovered;
        ToolTip.text: "点击" + (playing ? "暂停播放" : "开始播放");

        Text {
            anchors.centerIn: parent;
            text: playing ? "〓" : "▶";
            rotation: playing ? 90 : 0;
        }
    }

    /* 停止按钮 */
    Button {
        id: btn_stop;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_back.left;
        anchors.rightMargin: btn_open.anchors.rightMargin;
        width: 35;
        height: text_progress.height;
        text: "█";
        onClicked: {
            playing = false;
            slider_progress.value = 0;
            image_frame.change();
        }
        ToolTip.visible: hovered;
        ToolTip.text: "点击停止播放";
    }

    /* 后退按钮 */
    Button {
        id: btn_back;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_forward.left;
        anchors.rightMargin: btn_open.anchors.rightMargin;
        width: 40;
        height: text_progress.height;
        text: "❙◄";
        onClicked: {
            if (frameList.length > 1 && slider_progress.value > 0) {
                --slider_progress.value;
                image_frame.change();
            }
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击后退一帧";
    }

    /* 前进按钮 */
    Button {
        id: btn_forward;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_open.left;
        anchors.rightMargin: btn_open.anchors.rightMargin;
        width: 40;
        height: text_progress.height;
        text: "►❙";
        onClicked: {
            if (frameList.length > 1 && slider_progress.value < frameList.length - 1) {
                ++slider_progress.value;
                image_frame.change();
            }
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击前进一帧";
    }

    /* 打开按钮 */
    Button {
        id: btn_open;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: text_progress.left;
        anchors.rightMargin: 5;
        width: 35;
        height: text_progress.height;
        text: "✚";
        onClicked: {
            filedialog_open.open();
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击打开文件";
    }

    /* 帧间隔标题 */
    Text {
        id: text_interval;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.left: text_progress.right;
        anchors.leftMargin: btn_open.anchors.rightMargin;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        height: text_progress.height;
        text: "间隔:";
        font.pixelSize: 16;
    }

    /* 帧间隔 */
    MouseArea {
        id: area_interval;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.left: text_interval.right;
        anchors.leftMargin: btn_open.anchors.rightMargin;
        width: 40;
        height: text_progress.height;
        hoverEnabled: true;
        onEntered: {
            ToolTip.visible = true;
        }
        onExited: {
            ToolTip.visible = false;
        }
        ToolTip.text: "点击设置帧间隔(毫秒)";

        Rectangle {
            width: parent.width;
            height: parent.height * 0.85;
            anchors.verticalCenter: parent.verticalCenter;
            color: "white";
        }

        TextInput {
            id: textinput_interval;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.leftMargin: 2;
            anchors.right: parent.right;
            anchors.rightMargin: 2;
            horizontalAlignment: Text.AlignLeft;
            verticalAlignment: Text.AlignVCenter;
            clip: true;
            selectByMouse: true;
            validator: RegExpValidator {
                regExp: /^[0-9]{0,4}$/;
            }
            text: frameInterval;
            onEditingFinished: {
                var iNum = frameInterval;
                if (text.length > 0) {
                    iNum = parseInt(text);
                    if (isNaN(iNum) || 0 === iNum) {
                        iNum = frameInterval;
                    }
                }
                text = iNum;
                frameInterval = iNum
            }
            onAccepted: {
                focus = false;
            }
            font.pixelSize: 16;
        }
    }

    /* 清除按钮 */
    Button {
        id: btn_clear;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.left: area_interval.right;
        anchors.leftMargin: btn_open.anchors.rightMargin;
        width: 50;
        height: text_progress.height;
        text: "清除";
        font.pixelSize: 16;
        onClicked: {
            frameList = [];
            playing = false;
            slider_progress.value = 0;
            image_frame.change();
        }
        ToolTip.visible: hovered;
        ToolTip.text: "点击清除序列帧";
    }

    /* 更多按钮 */
    Button {
        id: btn_more;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.left: btn_clear.right;
        anchors.leftMargin: btn_open.anchors.rightMargin;
        width: 50;
        height: text_progress.height;
        text: "更多";
        font.pixelSize: 16;
        onClicked: {
            popup_more_dialog.open();
        }
        ToolTip.visible: hovered;
        ToolTip.text: "点击打开更多设置界面";
    }

    /* 文件对话框 */
    FileDialog {
        id: filedialog_open;
        title: "请选择要打开的文件";
        selectMultiple: true;
        nameFilters: [
            "图片文件 (*.bmp *.png *.jpg *.jpeg)"
        ];
        onAccepted: {
            var tmpList = [];
            for (var i = 0; i < fileUrls.length; ++i) {
                tmpList.push(fileUrls[i]);
            }
            frameList = tmpList;
            playing = false;
            slider_progress.value = 0;
            image_frame.change();
        }
    }

    /* 更多对话框 */
    Popup {
        id: popup_more_dialog;
        width: 280;
        height: 150;
        anchors.centerIn: parent;
        modal: true;
        closePolicy: Popup.NoAutoClose;
        property var okCallback: null;
        background: Rectangle {
            anchors.fill: parent;
            color: "white"
            radius: 5;

            Text {
                anchors.top: parent.top;
                anchors.topMargin: 10;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: "更多设置";
                font.pixelSize: 16;
            }

            Rectangle {
                anchors.left: parent.left;
                anchors.leftMargin: 10;
                anchors.right: parent.right;
                anchors.rightMargin: 10;
                anchors.top: parent.top;
                anchors.topMargin: 35;
                height: 1;
                color: "#BBBBBB";
            }

            /* 循环按钮 */
            Button {
                id: btn_loop;
                anchors.top: parent.top;
                anchors.topMargin: 50;
                anchors.left: parent.left;
                anchors.leftMargin: 25;
                width: 65;
                height: text_progress.height;
                text: loop ? "●循环" : "○循环";
                font.pixelSize: 16;
                onClicked: {
                    loop = !loop;
                }
                ToolTip.visible: hovered;
                ToolTip.text: "点击" + (loop ? "关闭" : "开启") + "循环播放";
            }

            Button {
                width: 50;
                height: 25;
                x: (parent.width - width) / 2;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                text: "确认";
                font.pixelSize: 16;
                onClicked: {
                    popup_more_dialog.close();
                    var tmpOkCB = popup_more_dialog.okCallback;
                    popup_more_dialog.okCallback = null;
                    if ('function' === typeof(tmpOkCB)) {
                        tmpOkCB();
                    }
                }
            }
        }
        function open(content, okCB) {
            if (visible) {
                return;
            }
            visible = true;
            okCallback = okCB;
        }
    }

    /* 消息对话框框 */
    Popup {
        id: popup_msg_dialog;
        width: 280;
        height: 150;
        anchors.centerIn: parent;
        modal: true;
        closePolicy: Popup.NoAutoClose;
        property var okCallback: null;
        background: Rectangle {
            anchors.fill: parent;
            color: "white"
            radius: 5;

            Text {
                anchors.top: parent.top;
                anchors.topMargin: 10;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: "提示";
                font.pixelSize: 16;
            }

            Rectangle {
                anchors.left: parent.left;
                anchors.leftMargin: 10;
                anchors.right: parent.right;
                anchors.rightMargin: 10;
                anchors.top: parent.top;
                anchors.topMargin: 35;
                height: 1;
                color: "#BBBBBB";
            }

            Text {
                id: text_msg_dialog_content;
                anchors.left: parent.left;
                anchors.leftMargin: 25;
                anchors.right: parent.right;
                anchors.rightMargin: 25;
                anchors.top: parent.top;
                anchors.topMargin: 50;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 55;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                clip: true;
                wrapMode: Text.WrapAnywhere;
                font.pixelSize: 16;
            }

            Button {
                width: 50;
                height: 25;
                x: {
                    if ('function' === typeof(popup_msg_dialog.okCallback)) {
                        return (parent.width / 2 - width) / 2;
                    }
                    return (parent.width - width) / 2;
                }
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                text: "确认";
                font.pixelSize: 16;
                onClicked: {
                    popup_msg_dialog.close();
                    var tmpOkCB = popup_msg_dialog.okCallback;
                    popup_msg_dialog.okCallback = null;
                    if ('function' === typeof(tmpOkCB)) {
                        tmpOkCB();
                    }
                }
            }

            Button {
                width: 50;
                height: 25;
                x: parent.width / 2 + (parent.width / 2 - width) / 2;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                text: "取消";
                font.pixelSize: 16;
                visible: 'function' === typeof(popup_msg_dialog.okCallback);
                onClicked: {
                    popup_msg_dialog.close();
                    popup_msg_dialog.okCallback = null;
                }
            }
        }
        function open(content, okCB) {
            if (visible) {
                return;
            }
            visible = true;
            var contentType = typeof(content);
            text_msg_dialog_content.text = 'string' === contentType || 'number' === contentType ? content : "Unsupport content type '" + contentType + "'";
            okCallback = okCB;
        }
    }

    /* 定时器 */
    Timer {
        interval: 100;
        repeat: true;
        running: true;
        onTriggered: {
            updateSize();
        }
    }

    /* 初始化 */
    Component.onCompleted: {
        updateSize();
    }

    /* 更新窗口大小和标题 */
    function updateSize() {
        if (container_frame.width > g_max_width) {
            g_max_width = container_frame.width;
        }
        if (container_frame.height > g_max_height) {
            g_max_height = container_frame.height;
        }
        proxy.setWindowWidth(5 + g_max_width + 5);
        proxy.setWindowHeight(5 + g_max_height + 10 + slider_progress.height + 10 + text_frame_name.height + 5 + text_progress.height + 5);
    }
}
