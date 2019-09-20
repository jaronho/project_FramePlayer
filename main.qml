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
    property bool showBorder: true;
    property bool whiteBackground: true;

    anchors.fill: parent;
    color: "#F5F5F5";

    /* 将数组arrNew插入数组arrOri中,index是想要插入的位置 */
    function insert(arrOri, index, arrNew) {
        if (index < 0) {
            index = 0;
        } else if (index > arrOri.length) {
            index = arrOri.length;
        }
        var arr = [];
        for (var i = 0; i < index; ++i) {
            arr.push(arrOri[i]);
        }
        for (var j = 0; j < arrNew.length; ++j) {
            arr.push(arrNew[j]);
        }
        for (var k = index; k < arrOri.length; ++k) {
            arr.push(arrOri[k]);
        }
        return arr;
    }

    function refresh() {
        /* 刷新进度条 */
        slider_progress.from = 0;
        slider_progress.to = (0 === frameList.length) ? 0 : frameList.length - 1;
        if (slider_progress.value > slider_progress.to) {
            slider_progress.value = slider_progress.to;
        }
        /* 刷新图片帧 */
        if (0 === frameList.length || slider_progress.value >= frameList.length) {
            image_frame.source = "";
        } else {
            image_frame.source = frameList[slider_progress.value].url;
            border_frame.updateOffset();
        }
        /* 刷新当前帧名 */
        text_frame_name.height = (0 === frameList.length) ? 0 : (1 === text_frame_name.lineCount ? 25 : (text_frame_name.lineCount * 18));
        text_frame_name.text = (0 === frameList.length) ? "" : frameList[slider_progress.value].url;
        /* 刷新帧进度 */
        text_progress.text = (0 === frameList.length ? 0 : slider_progress.value + 1) + "/" + frameList.length;
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Space:
            if (frameList.length > 1) {
                playing = !playing;
                if (playing && slider_progress.value >= frameList.length - 1) {
                    slider_progress.value = 0;
                }
            }
            break;
        case Qt.Key_Left:
            --slider_progress.value;
            break;
        case Qt.Key_Right:
            ++slider_progress.value;
            break;
        }
    }

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            parent.focus = true;
        }
    }

    /* 图片帧 */
    Rectangle {
        id: container_frame;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.topMargin: 5;
        clip: true;
        color: border_frame.visible ? "transparent" : (whiteBackground ? "white" : "black");
        width: {
            var w = image_frame.width;
            if (w < c_container_min_width) {
                w = c_container_min_width;
            } else if (w > c_container_max_width) {
                w = c_container_max_width;
            }
            return w + 2;
        }
        height: {
            var h = image_frame.height;
            if (h < c_container_min_height) {
                h = c_container_min_height;
            } else if (h > c_container_max_height) {
                h = c_container_max_height;
            }
            return h + 2;
        }

        Rectangle {
            id: border_frame;
            width: image_frame.width + 2;
            height: image_frame.height + 2;
            x: (parent.width - width) / 2 + xOffset();
            y: (parent.height - height) / 2 + yOffset();
            border.color: showBorder ? "grey" : "transparent";
            color: whiteBackground ? "white" : "black";
            visible: frameList.length > 0;

            function xOffset() {
                if (0 === frameList.length || slider_progress.value >= frameList.length) {
                    return 0;
                }
                return frameList[slider_progress.value].x;
            }

            function yOffset() {
                if (0 === frameList.length || slider_progress.value >= frameList.length) {
                    return 0;
                }
                return frameList[slider_progress.value].y;
            }

            function setOffset(x, y) {
                if (0 === frameList.length || slider_progress.value >= frameList.length) {
                    return;
                }
                frameList[slider_progress.value].x = x;
                frameList[slider_progress.value].y = y;
            }

            function updateOffset() {
                x = (parent.width - width) / 2 + xOffset();
                y = (parent.height - height) / 2 + yOffset();
            }

            Image {
                id: image_frame;
                anchors.centerIn: parent;
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
                        refresh();
                        if (slider_progress.value >= frameList.length - 1) {
                            if (!loop) {
                                playing = false;
                            }
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent;
            hoverEnabled: true;
            acceptedButtons: Qt.RightButton;
            onEntered: {
                if (frameList.length > 0 && !playing) {
                    ToolTip.text = "右击可编辑图片帧偏移位置, 当前偏移(" + border_frame.xOffset() + ", " + border_frame.yOffset() + ")";
                    ToolTip.visible = true;
                }
            }
            onExited: {
                ToolTip.visible = false;
            }
            onClicked: {
                if (Qt.RightButton === mouse.button) {
                    if (frameList.length > 0 && !playing) {
                        popup_offset_dialog.open(border_frame.xOffset(), border_frame.yOffset(), function(x, y) {
                            border_frame.setOffset(x, y);
                            border_frame.updateOffset();
                        });
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: container_frame;
        anchors.centerIn: container_frame;
        color: "transparent";
        border.color: showBorder ? "green" : "transparent";
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
        value: 0;
        stepSize: 1;
        ToolTip.visible: hovered;
        ToolTip.text: "拖动滑块改变播放进度, 当前第" + (0 === frameList.length ? 0 : value + 1) + "帧";
        onValueChanged: {
            refresh();
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
        text: 0 === frameList.length ? "" : frameList[slider_progress.value].url;
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
        anchors.rightMargin: btn_delete.anchors.rightMargin;
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
        anchors.right: btn_insert.left;
        anchors.rightMargin: btn_delete.anchors.rightMargin;
        width: 35;
        height: text_progress.height;
        text: "█";
        onClicked: {
            playing = false;
            slider_progress.value = 0;
            refresh();
        }
        ToolTip.visible: hovered;
        ToolTip.text: "点击停止播放";
    }

    /* 后退按钮 */
    /*Button {
        id: btn_back;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_forward.left;
        anchors.rightMargin: btn_delete.anchors.rightMargin;
        width: 40;
        height: text_progress.height;
        text: "❙◄";
        onClicked: {
            if (frameList.length > 1 && slider_progress.value > 0) {
                --slider_progress.value;
                refresh();
            }
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击后退一帧";
    }*/

    /* 前进按钮 */
    /*Button {
        id: btn_forward;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_append.left;
        anchors.rightMargin: btn_delete.anchors.rightMargin;
        width: 40;
        height: text_progress.height;
        text: "►❙";
        onClicked: {
            if (frameList.length > 1 && slider_progress.value < frameList.length - 1) {
                ++slider_progress.value;
                refresh();
            }
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击前进一帧";
    }*/

    /* 插入按钮 */
    Button {
        id: btn_insert;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_append.left;
        anchors.rightMargin: btn_delete.anchors.rightMargin;
        width: 35;
        height: text_progress.height;
        text: "INS";
        onClicked: {
            filedialog_open.mode = 1;
            filedialog_open.open();
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击在当前帧前面插入图片帧";
    }

    /* 添加按钮 */
    Button {
        id: btn_append;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: btn_delete.left;
        anchors.rightMargin: btn_delete.anchors.rightMargin;
        width: 35;
        height: text_progress.height;
        /*text: "✚";*/
        text: "ADD";
        onClicked: {
            filedialog_open.mode = 2;
            filedialog_open.open();
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击在当前帧后面添加图片帧";
    }

    /* 删除按钮 */
    Button {
        id: btn_delete;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.right: text_progress.left;
        anchors.rightMargin: 5;
        width: 35;
        height: text_progress.height;
        text: "DEL";
        onClicked: {
            if (frameList.length > 0) {
                popup_msg_dialog.open("是否删除第" + (slider_progress.value + 1) + "帧?", function() {
                    frameList.splice(slider_progress.value, 1);
                    refresh();
                })
            }
        }
        enabled: !playing;
        ToolTip.visible: hovered;
        ToolTip.text: "点击删除当前帧";
    }

    /* 帧间隔标题 */
    Text {
        id: text_interval;
        anchors.top: text_frame_name.bottom;
        anchors.topMargin: text_progress.anchors.topMargin;
        anchors.left: text_progress.right;
        anchors.rightMargin: btn_delete.anchors.rightMargin;
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
        anchors.rightMargin: btn_delete.anchors.rightMargin;
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
        anchors.leftMargin: btn_delete.anchors.rightMargin;
        width: 50;
        height: text_progress.height;
        text: "清除";
        font.pixelSize: 16;
        onClicked: {
            if (frameList.length > 0) {
                popup_msg_dialog.open("是否清空所有序列帧?", function() {
                    frameList = [];
                    playing = false;
                    slider_progress.value = 0;
                    refresh();
                })
            }
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
        anchors.leftMargin: btn_delete.anchors.rightMargin;
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
                tmpList.push({"url":fileUrls[i], "x":0, "y":0});
            }
            if (0 === frameList.length) {
                frameList = tmpList;
            } else {
                if (1 === mode) {
                    frameList = insert(frameList, slider_progress.value, tmpList);
                } else {    /* 2 === mode */
                    frameList = insert(frameList, slider_progress.value + 1, tmpList);
                }
            }
            refresh();
        }
        property int mode: 1;
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
                anchors.topMargin: btn_border.anchors.topMargin;
                anchors.right: btn_border.left;
                anchors.rightMargin: 20;
                width: 65;
                height: 25;
                text: loop ? "●循环" : "○循环";
                font.pixelSize: 16;
                onClicked: {
                    loop = !loop;
                }
                ToolTip.visible: hovered;
                ToolTip.text: "点击" + (loop ? "关闭" : "开启") + "循环播放";
            }

            /* 显示边框按钮 */
            Button {
                id: btn_border;
                anchors.top: parent.top;
                anchors.topMargin: 50;
                anchors.horizontalCenter: parent.horizontalCenter;
                width: 65;
                height: 25;
                text: showBorder ? "●边框" : "○边框";
                font.pixelSize: 16;
                onClicked: {
                    showBorder = !showBorder;
                }
                ToolTip.visible: hovered;
                ToolTip.text: "点击" + (showBorder ? "隐藏" : "显示") + "边框";
            }

            /* 背景颜色按钮 */
            Button {
                id: btn_background;
                anchors.top: parent.top;
                anchors.topMargin: 50;
                anchors.left: btn_border.right;
                anchors.leftMargin: btn_loop.anchors.rightMargin;
                width: 65;
                height: 25;
                text: whiteBackground ? "○白色" : "●黑色";
                font.pixelSize: 16;
                onClicked: {
                    whiteBackground = !whiteBackground;
                }
                ToolTip.visible: hovered;
                ToolTip.text: "点击设置为" + (whiteBackground ? "黑色" : "白色") + "背景";
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
        function open(okCB) {
            if (visible) {
                return;
            }
            visible = true;
            okCallback = okCB;
        }
    }

    /* 帧偏移位置编辑框 */
    Popup {
        id: popup_offset_dialog;
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
                text: "帧偏移位置";
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
                id: text_offset_x;
                anchors.top: parent.top;
                anchors.topMargin: 60;
                anchors.right: area_offset_x.left;
                anchors.rightMargin: 2;
                verticalAlignment: Text.AlignVCenter;
                height: 25;
                text: "x:";
                font.pixelSize: 16;
            }

            MouseArea {
                id: area_offset_x;
                anchors.top: parent.top;
                anchors.topMargin: text_offset_x.anchors.topMargin;
                anchors.right: text_offset_y.left;
                anchors.rightMargin: 50;
                width: 40;
                height: 25;

                Rectangle {
                    width: parent.width;
                    height: parent.height * 0.85;
                    anchors.verticalCenter: parent.verticalCenter;
                    color: "#DDDDDD";
                }

                TextInput {
                    id: textinput_offset_x;
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
                        regExp: /^(\-?)[0-9]{0,4}$/;
                    }
                    text: "0";
                    onEditingFinished: {
                        var iNum = 0;
                        if (text.length > 0) {
                            iNum = parseInt(text);
                            if (isNaN(iNum) || 0 === iNum) {
                                iNum = 0;
                            }
                        }
                        text = iNum;
                    }
                    onAccepted: {
                        focus = false;
                    }
                    font.pixelSize: 16;
                }
            }

            Text {
                id: text_offset_y;
                anchors.top: parent.top;
                anchors.topMargin: text_offset_x.anchors.topMargin;
                anchors.left: parent.left;
                anchors.leftMargin: parent.width / 2 + 20;
                verticalAlignment: Text.AlignVCenter;
                height: 25;
                text: "y:";
                font.pixelSize: 16;
            }

            MouseArea {
                id: area_offset_y;
                anchors.top: parent.top;
                anchors.topMargin: text_offset_x.anchors.topMargin;
                anchors.left: text_offset_y.right;
                anchors.leftMargin: 2;
                width: 40;
                height: 25;

                Rectangle {
                    width: parent.width;
                    height: parent.height * 0.85;
                    anchors.verticalCenter: parent.verticalCenter;
                    color: "#DDDDDD";
                }

                TextInput {
                    id: textinput_offset_y;
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
                        regExp: /^(\-?)[0-9]{0,4}$/;
                    }
                    text: "0";
                    onEditingFinished: {
                        var iNum = 0;
                        if (text.length > 0) {
                            iNum = parseInt(text);
                            if (isNaN(iNum) || 0 === iNum) {
                                iNum = 0;
                            }
                        }
                        text = iNum;
                    }
                    onAccepted: {
                        focus = false;
                    }
                    font.pixelSize: 16;
                }
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
                    popup_offset_dialog.close();
                    var tmpOkCB = popup_offset_dialog.okCallback;
                    popup_offset_dialog.okCallback = null;
                    if ('function' === typeof(tmpOkCB)) {
                        tmpOkCB(parseInt(textinput_offset_x.text), parseInt(textinput_offset_y.text));
                    }
                }
            }
        }
        function open(x, y, okCB) {
            if (visible) {
                return;
            }
            textinput_offset_x.text = ('number' === typeof(x) && x >= 0) ? x : 0;
            textinput_offset_y.text = ('number' === typeof(y) && y >= 0) ? y : 0;
            visible = true;
            okCallback = okCB;
        }
    }

    /* 消息对话框 */
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
