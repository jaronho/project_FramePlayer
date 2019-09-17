import QtQuick 2.12
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.12

Item {
    anchors.fill: parent;

    Timer {
        interval: 100;
        repeat: true;
        running: true;
        onTriggered: {
            updateSizeAndTitle();
        }
    }

    /* 背景颜色 */
    Rectangle {
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: container.top;
        color: "#F5F5F5";
    }

    Rectangle {
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: container.bottom;
        anchors.bottom: parent.bottom;
        color: "#F5F5F5";
    }

    Rectangle {
        anchors.left: parent.left;
        anchors.right: container.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        color: "#F5F5F5";
    }

    Rectangle {
        anchors.left: container.right;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        color: "#F5F5F5";
    }

    Rectangle {
        anchors.fill: parent;
        color: "transparent";
        border.color: "gray";

        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Left:
                proxy.setWindowX(proxy.getWindowX() - 1);
                break;
            case Qt.Key_Right:
                proxy.setWindowX(proxy.getWindowX() + 1);
                break;
            case Qt.Key_Up:
                proxy.setWindowY(proxy.getWindowY() - 1);
                break;
            case Qt.Key_Down:
                proxy.setWindowY(proxy.getWindowY() + 1);
                break;
            }
        }

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                parent.focus = true;
            }
        }
    }

    /* 画布宽高设置 */
    Item {
        id: item_canvas_size_setting;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.topMargin: 10;
        width: container.width;
        height: input_canvas_width.height;
        clip: true;

        /* 画布宽 */
        Text {
            id: text_canvas_width_title;
            anchors.verticalCenter: input_canvas_width.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            text: qsTr("宽:");
            color: "#000000";
            font.pixelSize: 20;
        }

        XTextInput {
            id: input_canvas_width;
            anchors.left: text_canvas_width_title.right;
            anchors.leftMargin: 5;
            inputValidator: RegExpValidator {   /* 数字 */
                regExp: /^[0-9]{0,}$/;
            }
            inputText: self.renderWidth;
            inputTextColor: "#000000";
            inputFont.pixelSize: 20;
            hintText: "";
            width: 60;
            height: 28;
            onInputAccepted: function() {
                var width = 0;
                if (inputText.length > 0) {
                    width = parseInt(inputText);
                }
                if (width < 400) {
                    width = 400;
                } else if (width > 1000) {
                    width = 1000;
                }
                inputText = width.toString();
                self.renderWidth = width;
                updateSizeAndTitle();
            }
        }

        /* 画布宽间距 */
        Text {
            id: text_canvas_width_margin_title;
            anchors.verticalCenter: input_canvas_width.verticalCenter;
            anchors.left: input_canvas_width.right;
            anchors.leftMargin: 5;
            text: qsTr("间距:");
            color: "#000000";
            font.pixelSize: 20;
        }

        XTextInput {
            id: input_canvas_width_margin;
            anchors.left: text_canvas_width_margin_title.right;
            anchors.leftMargin: 5;
            inputValidator: RegExpValidator {   /* 数字 */
                regExp: /^[0-9]{0,}$/;
            }
            inputText: self.widthMargin;
            inputTextColor: "#000000";
            inputFont.pixelSize: 20;
            hintText: "";
            width: 60;
            height: 28;
            onInputAccepted: function() {
                var width = 0;
                if (inputText.length > 0) {
                    width = parseInt(inputText);
                }
                if (width < 0) {
                    width = 0;
                } else if (width > 1000) {
                    width = 1000;
                }
                inputText = width.toString();
                self.widthMargin = width;
                updateSizeAndTitle();
                button_stay_top.updateWidth();
            }
        }

        /* 置顶按钮 */
        XButton {
            id: button_stay_top;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.verticalCenter: input_canvas_width.verticalCenter;
            width: self.widthMargin < 25 ? 25 : 70;
            height: 28;
            hint.text: hintText();
            hint.font.pixelSize: 20;
            ToolTip.visible: hovered;
            ToolTip.text: toolTipText();
            onButtonClick: function() {
                proxy.setWindowOnTop(!proxy.isWindowOnTop());
                hint.text = hintText();
                ToolTip.text = toolTipText();
            }
            function updateWidth() {
                if (self.widthMargin < 25) {
                    width = 25;
                } else {
                    width = 70;
                }
                hint.text = hintText();
            }
            function hintText() {
                if (self.widthMargin < 25) {
                    return proxy.isWindowOnTop() ? qsTr("●") : qsTr("○");
                }
                return proxy.isWindowOnTop() ? qsTr("●置顶") : qsTr("○置顶");
            }
            function toolTipText() {
                return "设置窗口是否一直置于前端显示, 当前: " + (proxy.isWindowOnTop() ? "置顶" : "非置顶");
            }
        }

        /* 画布高 */
        Text {
            id: text_canvas_height_title;
            anchors.verticalCenter: input_canvas_height.verticalCenter;
            anchors.right: input_canvas_height.left;
            anchors.rightMargin: 5;
            text: qsTr("高:");
            color: "#000000";
            font.pixelSize: 20;
        }

        XTextInput {
            id: input_canvas_height;
            anchors.right: text_canvas_height_margin_title.left;
            anchors.rightMargin: 5;
            inputValidator: RegExpValidator {   /* 数字 */
                regExp: /^[0-9]{0,}$/;
            }
            inputText: self.renderHeight;
            inputTextColor: "#000000";
            inputFont.pixelSize: 20;
            hintText: "";
            width: 60;
            height: 28;
            onInputAccepted: function() {
                var height = 0;
                if (inputText.length > 0) {
                    height = parseInt(inputText);
                }
                if (height < 200) {
                    height = 200;
                } else if (height > 600) {
                    height = 600;
                }
                inputText = height.toString();
                self.renderHeight = height;
                updateSizeAndTitle();
            }
        }

        /* 间距高 */
        Text {
            id: text_canvas_height_margin_title;
            anchors.verticalCenter: input_canvas_height.verticalCenter;
            anchors.right: input_canvas_height_margin.left;
            anchors.rightMargin: 5;
            text: qsTr("间距:");
            color: "#000000";
            font.pixelSize: 20;
        }

        XTextInput {
            id: input_canvas_height_margin;
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            inputValidator: RegExpValidator {   /* 数字 */
                regExp: /^[0-9]{0,}$/;
            }
            inputText: self.heightMargin;
            inputTextColor: "#000000";
            inputFont.pixelSize: 20;
            hintText: "";
            width: 60;
            height: 28;
            onInputAccepted: function() {
                var height = 0;
                if (inputText.length > 0) {
                    height = parseInt(inputText);
                }
                if (height < 0) {
                    height = 0;
                } else if (height > 600) {
                    height = 600;
                }
                inputText = height.toString();
                self.heightMargin = height;
                updateSizeAndTitle();
            }
        }
    }

    /* 切换按钮 */
    XButton {
        id: button_switch;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: item_canvas_size_setting.bottom;
        anchors.topMargin: 5;
        width: 210;
        height: 30;
        hint.text: self.modeQuadratic ? qsTr("切换为三次贝塞尔曲线") : qsTr("切换为二次贝塞尔曲线");
        hint.font.pixelSize: 20;
        onButtonClick: function() {
            listmodel_curve.clear();
            self.modeQuadratic = !self.modeQuadratic;
            updateSizeAndTitle();
            if (self.modeQuadratic) {
                for (var i = 0; i < canvas_quadratic.list_curve.length; ++i) {
                    listmodel_curve.append(canvas_quadratic.list_curve[i]);
                }
            } else {
                for (var j = 0; j < canvas_cubic.list_curve.length; ++j) {
                    listmodel_curve.append(canvas_cubic.list_curve[j]);
                }
            }
        }
    }

    /* 左上角 */
    Text {
        id: text_corner_left_top;
        anchors.left: container.left;
        anchors.top: item_canvas_size_setting.bottom;
        anchors.topMargin: 25;
        text: "(" + (0 == self.widthMargin ? "" : "-") + self.widthMargin + ", " + (0 == self.heightMargin ? "" : "-") + self.heightMargin + ")";
        font.pixelSize: 16;
    }

    /* 右上角 */
    Text {
        id: text_corner_right_top;
        anchors.right: container.right;
        anchors.top: item_canvas_size_setting.bottom;
        anchors.topMargin: 25;
        text: "(" + (self.renderWidth + self.widthMargin) + ", " + (0 == self.heightMargin ? "" : "-") + self.heightMargin + ")";
        font.pixelSize: 16;
    }

    Item {
        id: container;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: text_corner_left_top.bottom;
        width: self.renderWidth + 2 * self.widthMargin;
        height: self.renderHeight + 2 * self.heightMargin;

        /* 三次贝塞尔曲线画布 */
        Canvas {
            property var list_curve: [];
            id: canvas_cubic;
            anchors.fill: parent;
            visible: !self.modeQuadratic;
            function render() {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, self.renderWidth + 2 * self.widthMargin, self.renderHeight + 2 * self.heightMargin);
                ctx.fillStyle = Qt.rgba(221 / 255, 221 / 255, 221 / 255, slider_opacity.value);
                ctx.fillRect(0, 0, self.renderWidth + 2 * self.widthMargin, self.renderHeight + 2 * self.heightMargin);
                ctx.fillStyle = Qt.rgba(238 / 255, 238 / 255, 238 / 255, slider_opacity.value);
                ctx.fillRect(self.widthMargin, self.heightMargin, self.renderWidth, self.renderHeight);
                ctx.strokeStyle = "black";
                ctx.strokeRect(self.widthMargin, self.heightMargin, self.renderWidth, self.renderHeight);
                for (var i = 0; i < list_curve.length; ++i) {
                    var pt = list_curve[i];
                    /* 坐标偏移计算 */
                    var startX = pt.start_x + self.widthMargin;
                    var startY = pt.start_y + self.heightMargin;
                    var control1X = pt.control_1_x + self.widthMargin;
                    var control1Y = pt.control_1_y + self.heightMargin;
                    var control2X = pt.control_2_x + self.widthMargin;
                    var control2Y = pt.control_2_y + self.heightMargin;
                    var endX = pt.end_x + self.widthMargin;
                    var endY = pt.end_y + self.heightMargin;
                    /* 绘制曲线 */
                    if (pt.show) {
                        self.drawCubicBezierCruve(ctx, startX, startY, control1X, control1Y, control2X, control2Y, endX, endY, self.curve_width, "#000000");
                        if (1 === pt.debug || 2 === pt.debug) {
                            if (2 === pt.debug) {
                                self.drawLine(ctx, startX, startY, control1X, control1Y, 1, "#FF0000");
                                self.drawLine(ctx, endX, endY, control2X, control2Y, 1, "#FF0000");
                            }
                            /* 绘制起点 */
                            self.drawCircle(ctx, startX, startY, self.point_radius, "#FF0000");
                            /* 绘制控制点1 */
                            self.drawCircle(ctx, control1X, control1Y, self.point_radius, "#006400");
                            /* 绘制控制点2 */
                            self.drawCircle(ctx, control2X, control2Y, self.point_radius, "#00868B");
                            /* 绘制终点 */
                            self.drawCircle(ctx, endX, endY, self.point_radius, "#0000FF");
                        }
                    }
                }
                requestAnimationFrame(render);
            }
            Component.onCompleted: {
                requestAnimationFrame(render);
            }
        }

        /* 二次贝塞尔曲线画布 */
        Canvas {
            property var list_curve: [];
            id: canvas_quadratic;
            anchors.fill: parent;
            visible: self.modeQuadratic;
            function render() {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, self.renderWidth + 2 * self.widthMargin, self.renderHeight + 2 * self.heightMargin);
                ctx.fillStyle = Qt.rgba(221 / 255, 221 / 255, 221 / 255, slider_opacity.value);
                ctx.fillRect(0, 0, self.renderWidth + 2 * self.widthMargin, self.renderHeight + 2 * self.heightMargin);
                ctx.fillStyle = Qt.rgba(238 / 255, 238 / 255, 238 / 255, slider_opacity.value);
                ctx.fillRect(self.widthMargin, self.heightMargin, self.renderWidth, self.renderHeight);
                ctx.strokeStyle = "black";
                ctx.strokeRect(self.widthMargin, self.heightMargin, self.renderWidth, self.renderHeight);
                for (var i = 0; i < list_curve.length; ++i) {
                    var pt = list_curve[i];
                    /* 坐标偏移计算 */
                    var startX = pt.start_x + self.widthMargin;
                    var startY = pt.start_y + self.heightMargin;
                    var control1X = pt.control_1_x + self.widthMargin;
                    var control1Y = pt.control_1_y + self.heightMargin;
                    var endX = pt.end_x + self.widthMargin;
                    var endY = pt.end_y + self.heightMargin;
                    /* 绘制曲线 */
                    if (pt.show) {
                        self.drawQuadraticBezierCruve(ctx, startX, startY, control1X, control1Y, endX, endY, self.curve_width, "#000000");
                        if (1 === pt.debug || 2 === pt.debug) {
                            if (2 === pt.debug) {
                                self.drawLine(ctx, startX, startY, control1X, control1Y, 1, "#FF0000");
                                self.drawLine(ctx, endX, endY, control1X, control1Y, 1, "#FF0000");
                            }
                            /* 绘制起点 */
                            self.drawCircle(ctx, startX, startY, self.point_radius, "#FF0000");
                            /* 绘制控制点 */
                            self.drawCircle(ctx, control1X, control1Y, self.point_radius, "#006400");
                            /* 绘制终点 */
                            self.drawCircle(ctx, endX, endY, self.point_radius, "#0000FF");
                        }
                    }
                }
                requestAnimationFrame(render);
            }
            Component.onCompleted: {
                requestAnimationFrame(render);
            }
        }

        /* 函数模块 */
        QtObject {
            id: self;
            readonly property int curve_width: 1;   /* 曲线宽度 */
            readonly property int point_radius: 3;  /* 圆点半径 */
            property int renderWidth: 480;
            property int renderHeight: 240;
            property int widthMargin: 50;
            property int heightMargin: 50;
            property bool modeQuadratic: true;      /* 是否二次贝塞尔模式 */
            /* 绘制二次贝塞尔曲线 */
            function drawQuadraticBezierCruve(ctx, startX, startY, controlX, controlY, endX, endY, width, style) {
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.quadraticCurveTo(controlX, controlY, endX, endY);
                ctx.lineWidth = width;
                ctx.strokeStyle = style;
                ctx.stroke();
            }
            /* 绘制三次贝塞尔曲线 */
            function drawCubicBezierCruve(ctx, startX, startY, control1X, control1Y, control2X, control2Y, endX, endY, width, style) {
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.bezierCurveTo(control1X, control1Y, control2X, control2Y, endX, endY);
                ctx.lineWidth = width;
                ctx.strokeStyle = style;
                ctx.stroke();
            }
            /* 绘制直线 */
            function drawLine(ctx, x1, y1, x2, y2, width, style) {
                ctx.beginPath();
                ctx.moveTo(x1, y1);
                ctx.lineTo(x2, y2);
                ctx.lineWidth = width;
                ctx.strokeStyle = style;
                ctx.stroke();
            }
            /* 绘制圆点 */
            function drawCircle(ctx, x, y, radius, style) {
                ctx.beginPath();
                ctx.arc(x, y, radius, 0, 360, true);
                ctx.fillStyle = style;
                ctx.fill();
            }
            /* 点是否在圆内 */
            function isPointInCircle(centerX, centerY, radius, x, y) {
                var distance = Math.sqrt(Math.pow(x - centerX, 2) + Math.pow(y - centerY, 2));
                return distance <= radius;
            }
        }

        /* 鼠标操作区域 */
        MouseArea {
            property bool just_press: false;    /* 是否刚按下 */
            property int curve_index: -1;       /* 曲线索引 */
            property int point_type: 0;         /* 点类型:1.起点,2.控制点1,3.控制点2,4.终点 */
            id: mouse_area;
            x: 0;
            y: 0;
            width: self.renderWidth + 2 * self.widthMargin;
            height: self.renderHeight + 2 * self.heightMargin;
            acceptedButtons: Qt.LeftButton | Qt.RightButton;
            onClicked: {
                if (Qt.RightButton === mouse.button) {
                    var curveIndex = -1;
                    var pointType = 0;
                    if (self.modeQuadratic) { /* 二次贝塞尔曲线 */
                        for (var i = canvas_quadratic.list_curve.length - 1; i >= 0; --i) {
                            var pt1 = canvas_quadratic.list_curve[i];
                            if (pt1.show && (1 === pt1.debug || 2 === pt1.debug)) {
                                if (self.isPointInCircle(pt1.end_x + self.widthMargin, pt1.end_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了终点 */
                                    curveIndex = i;
                                    pointType = 4;
                                    break;
                                } else if (self.isPointInCircle(pt1.control_1_x + self.widthMargin, pt1.control_1_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了控制点 */
                                    curveIndex = i;
                                    pointType = 2;
                                    break;
                                } else if (self.isPointInCircle(pt1.start_x + self.widthMargin, pt1.start_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了起点 */
                                    curveIndex = i;
                                    pointType = 1;
                                    break;
                                }
                            }
                        }
                        if (curveIndex >= 0) {
                            pt1 = canvas_quadratic.list_curve[curveIndex];
                            var x1 = 0, y1 = 0;
                            if (1 === pointType) {
                                x1 = pt1.start_x;
                                y1 = pt1.start_y;
                            } else if (2 === pointType) {
                                x1 = pt1.control_1_x;
                                y1 = pt1.control_1_y;
                            } else if (4 === pointType) {
                                x1 = pt1.end_x;
                                y1 = pt1.end_y;
                            } else {
                                return;
                            }
                            popup_edit_dialog.open(x1, y1, pt1.debug, function(x, y) {
                                if (1 === pointType) {
                                    pt1.start_x = x;
                                    pt1.start_y = y;
                                    listmodel_curve.get(curveIndex).start_x = x;
                                    listmodel_curve.get(curveIndex).start_y = y;
                                } else if (2 === pointType) {
                                    pt1.control_1_x = x;
                                    pt1.control_1_y = y;
                                    listmodel_curve.get(curveIndex).control_1_x = x;
                                    listmodel_curve.get(curveIndex).control_1_y = y;
                                } else if (4 === pointType) {
                                    pt1.end_x = x;
                                    pt1.end_y = y;
                                    listmodel_curve.get(curveIndex).end_x = x;
                                    listmodel_curve.get(curveIndex).end_y = y;
                                }
                            }, function(debug) {
                                pt1.debug = debug;
                                listmodel_curve.get(curveIndex).debug = debug;
                            });
                        }
                    } else {  /* 三次贝塞尔曲线 */
                        for (var j = canvas_cubic.list_curve.length - 1; j >= 0; --j) {
                            var pt2 = canvas_cubic.list_curve[j];
                            if (pt2.show && (1 === pt2.debug || 2 === pt2.debug)) {
                                if (self.isPointInCircle(pt2.end_x + self.widthMargin, pt2.end_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了终点 */
                                    curveIndex = j;
                                    pointType = 4;
                                    break;
                                } else if (self.isPointInCircle(pt2.control_2_x + self.widthMargin, pt2.control_2_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了控制点2 */
                                    curveIndex = j;
                                    pointType = 3;
                                    break;
                                } else if (self.isPointInCircle(pt2.control_1_x + self.widthMargin, pt2.control_1_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了控制点1 */
                                    curveIndex = j;
                                    pointType = 2;
                                    break;
                                } else if (self.isPointInCircle(pt2.start_x + self.widthMargin, pt2.start_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了起点 */
                                    curveIndex = j;
                                    pointType = 1;
                                    break;
                                }
                            }
                        }
                        if (curveIndex >= 0) {
                            pt2 = canvas_cubic.list_curve[curveIndex];
                            var x2 = 0, y2 = 0;
                            if (1 === pointType) {
                                x2 = pt2.start_x;
                                y2 = pt2.start_y;
                            } else if (2 === pointType) {
                                x2 = pt2.control_1_x;
                                y2 = pt2.control_1_y;
                            } else if (3 === pointType) {
                                x2 = pt2.control_2_x;
                                y2 = pt2.control_2_y;
                            } else if (4 === pointType) {
                                x2 = pt2.end_x;
                                y2 = pt2.end_y;
                            } else {
                                return;
                            }
                            popup_edit_dialog.open(x2, y2, pt2.debug, function(x, y) {
                                if (1 === pointType) {
                                    pt2.start_x = x;
                                    pt2.start_y = y;
                                    listmodel_curve.get(curveIndex).start_x = x;
                                    listmodel_curve.get(curveIndex).start_y = y;
                                } else if (2 === pointType) {
                                    pt2.control_1_x = x;
                                    pt2.control_1_y = y;
                                    listmodel_curve.get(curveIndex).control_1_x = x;
                                    listmodel_curve.get(curveIndex).control_1_y = y;
                                } else if (3 === pointType) {
                                    pt2.control_2_x = x;
                                    pt2.control_2_y = y;
                                    listmodel_curve.get(curveIndex).control_2_x = x;
                                    listmodel_curve.get(curveIndex).control_2_y = y;
                                } else if (4 === pointType) {
                                    pt2.end_x = x;
                                    pt2.end_y = y;
                                    listmodel_curve.get(curveIndex).end_x = x;
                                    listmodel_curve.get(curveIndex).end_y = y;
                                }
                            }, function(debug) {
                                pt2.debug = debug;
                                listmodel_curve.get(curveIndex).debug = debug;
                            });
                        }
                    }
                }
            }
            onPressed: {
                if (Qt.LeftButton !== mouse.button) {
                    return;
                }
                just_press = true;
                curve_index = -1;
                point_type = 0;
                if (self.modeQuadratic) { /* 二次贝塞尔曲线 */
                    for (var i = canvas_quadratic.list_curve.length - 1; i >= 0; --i) {
                        var pt1 = canvas_quadratic.list_curve[i];
                        if (pt1.show && (1 === pt1.debug || 2 === pt1.debug)) {
                            if (self.isPointInCircle(pt1.end_x + self.widthMargin, pt1.end_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了终点 */
                                curve_index = i;
                                point_type = 4;
                                break;
                            } else if (self.isPointInCircle(pt1.control_1_x + self.widthMargin, pt1.control_1_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了控制点 */
                                curve_index = i;
                                point_type = 2;
                                break;
                            } else if (self.isPointInCircle(pt1.start_x + self.widthMargin, pt1.start_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了起点 */
                                curve_index = i;
                                point_type = 1;
                                break;
                            }
                        }
                    }
                } else {  /* 三次贝塞尔曲线 */
                    for (var j = canvas_cubic.list_curve.length - 1; j >= 0; --j) {
                        var pt2 = canvas_cubic.list_curve[j];
                        if (pt2.show && (1 === pt2.debug || 2 === pt2.debug)) {
                            if (self.isPointInCircle(pt2.end_x + self.widthMargin, pt2.end_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了终点 */
                                curve_index = j;
                                point_type = 4;
                                break;
                            } else if (self.isPointInCircle(pt2.control_2_x + self.widthMargin, pt2.control_2_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了控制点2 */
                                curve_index = j;
                                point_type = 3;
                                break;
                            } else if (self.isPointInCircle(pt2.control_1_x + self.widthMargin, pt2.control_1_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了控制点1 */
                                curve_index = j;
                                point_type = 2;
                                break;
                            } else if (self.isPointInCircle(pt2.start_x + self.widthMargin, pt2.start_y + self.heightMargin, self.point_radius, mouseX, mouseY)) {  /* 点击了起点 */
                                curve_index = j;
                                point_type = 1;
                                break;
                            }
                        }
                    }
                }
                if (curve_index >= 0) {
                    listview_curve.positionViewAtIndex(curve_index, ListView.Center);
                }
            }
            onReleased: {
                just_press = false;
                curve_index = -1;
                point_type = 0;
            }
            onMouseXChanged: {
                if (just_press) {
                    return;
                }
                if (self.modeQuadratic) { /* 二次贝塞尔曲线 */
                    if (curve_index >= 0) {
                        var pt1 = canvas_quadratic.list_curve[curve_index];
                        if (pt1.show && (1 === pt1.debug || 2 === pt1.debug)) {
                            if (1 === point_type) {
                                pt1.start_x = mouseX - self.widthMargin;
                                listmodel_curve.get(curve_index).start_x = mouseX - self.widthMargin;
                            } else if (2 === point_type) {
                                pt1.control_1_x = mouseX - self.widthMargin;
                                listmodel_curve.get(curve_index).control_1_x = mouseX - self.widthMargin;
                            } else if (4 === point_type) {
                                pt1.end_x = mouseX - self.widthMargin;
                                listmodel_curve.get(curve_index).end_x = mouseX - self.widthMargin;
                            }
                        }
                    }
                } else {  /* 三次贝塞尔曲线 */
                    if (curve_index >= 0) {
                        var pt2 = canvas_cubic.list_curve[curve_index];
                        if (pt2.show && (1 === pt2.debug || 2 === pt2.debug)) {
                            if (1 === point_type) {
                                pt2.start_x = mouseX - self.widthMargin;
                                listmodel_curve.get(curve_index).start_x = mouseX - self.widthMargin;
                            } else if (2 === point_type) {
                                pt2.control_1_x = mouseX - self.widthMargin;
                                listmodel_curve.get(curve_index).control_1_x = mouseX - self.widthMargin;
                            } else if (3 === point_type) {
                                pt2.control_2_x = mouseX - self.widthMargin;
                                listmodel_curve.get(curve_index).control_2_x = mouseX - self.widthMargin;
                            } else if (4 === point_type) {
                                pt2.end_x = mouseX - self.widthMargin;
                                listmodel_curve.get(curve_index).end_x = mouseX - self.widthMargin;
                            }
                        }
                    }
                }
            }
            onMouseYChanged: {
                if (just_press) {
                    just_press = false;
                    return;
                }
                if (self.modeQuadratic) { /* 二次贝塞尔曲线 */
                    if (curve_index >= 0) {
                        var pt1 = canvas_quadratic.list_curve[curve_index];
                        if (pt1.show && (1 === pt1.debug || 2 === pt1.debug)) {
                            if (1 === point_type) {
                                pt1.start_y = mouseY - self.heightMargin;
                                listmodel_curve.get(curve_index).start_y = mouseY - self.heightMargin;
                            } else if (2 === point_type) {
                                pt1.control_1_y = mouseY - self.heightMargin;
                                listmodel_curve.get(curve_index).control_1_y = mouseY - self.heightMargin;
                            } else if (4 === point_type) {
                                pt1.end_y = mouseY - self.heightMargin;
                                listmodel_curve.get(curve_index).end_y = mouseY - self.heightMargin;
                            }
                        }
                    }
                } else {  /* 三次贝塞尔曲线 */
                    if (curve_index >= 0) {
                        var pt2 = canvas_cubic.list_curve[curve_index];
                        if (pt2.show && (1 === pt2.debug || 2 === pt2.debug)) {
                            if (1 === point_type) {
                                pt2.start_y = mouseY - self.heightMargin;
                                listmodel_curve.get(curve_index).start_y = mouseY - self.heightMargin;
                            } else if (2 === point_type) {
                                pt2.control_1_y = mouseY - self.heightMargin;
                                listmodel_curve.get(curve_index).control_1_y = mouseY - self.heightMargin;
                            } else if (3 === point_type) {
                                pt2.control_2_y = mouseY - self.heightMargin;
                                listmodel_curve.get(curve_index).control_2_y = mouseY - self.heightMargin;
                            } else if (4 === point_type) {
                                pt2.end_y = mouseY - self.heightMargin;
                                listmodel_curve.get(curve_index).end_y = mouseY - self.heightMargin;
                            }
                        }
                    }
                }
            }
        }
    }

    /* 左下角 */
    Text {
        id: text_corner_left_bottom;
        anchors.left: container.left;
        anchors.top: container.bottom;
        text: "(" + (0 == self.widthMargin ? "" : "-") + self.widthMargin + ", " + (self.renderHeight + self.heightMargin) + ")";
        font.pixelSize: 16;
    }

    /* 右下角 */
    Text {
        id: text_corner_right_bottom;
        anchors.right: container.right;
        anchors.top: container.bottom;
        text: "(" + (self.renderWidth + self.widthMargin) + ", " + (self.renderHeight + self.heightMargin) + ")";
        font.pixelSize: 16;
    }

    /* 透明控制 */
    Slider {
        id: slider_opacity;
        anchors.verticalCenter: button_add.verticalCenter;
        anchors.right: button_add.left;
        anchors.rightMargin: 40;
        width: 130;
        height: 25;
        from: 0;
        to: 1;
        value: 1;
        stepSize: 0.01;
        ToolTip.visible: hovered;
        ToolTip.text: "可拖动滑块改变窗口透明度, 当前透明度: " + (value * 100).toFixed(0) + "%";
    }

    /* 添加按钮 */
    XButton {
        id: button_add;
        anchors.top: container.bottom;
        anchors.topMargin: 5;
        x: (parent.width / 2) + 20;
        hint.text: "添加曲线";
        hint.color: "#000000";
        hint.font.pixelSize: 20;
        width: 90;
        height: 30;
        onButtonClick: function() {
            if (self.modeQuadratic) {
                var pt1 = {
                    start_x: 0,
                    start_y: self.renderHeight,
                    control_1_x: self.renderWidth/2,
                    control_1_y: self.renderHeight/2,
                    control_2_x: 0,
                    control_2_y: 0,
                    end_x: self.renderWidth,
                    end_y: 0,
                    show: true,
                    debug: 1
                };
                canvas_quadratic.list_curve.push(pt1);
                listmodel_curve.append(pt1);
            } else {
                var pt2 = {
                    start_x: 0,
                    start_y: self.renderHeight,
                    control_1_x: self.renderWidth/2 - 100,
                    control_1_y: self.renderHeight/2 + 100,
                    control_2_x: self.renderWidth/2 + 100,
                    control_2_y: self.renderHeight/2 - 100,
                    end_x: self.renderWidth,
                    end_y: 0,
                    show: true,
                    debug: 1
                };
                canvas_cubic.list_curve.push(pt2);
                listmodel_curve.append(pt2);
            }
        }
    }

    /* 分割线 */
    Rectangle {
        width: container.width;
        height: 1;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: button_add.bottom;
        anchors.topMargin: 5;
        color: "#BBBBBB";
    }

    ListView {
        id: listview_curve;
        width: self.renderWidth;
        height: self.modeQuadratic ? 213 : 279;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: button_add.bottom;
        anchors.topMargin: 10;
        model: ListModel {
            id: listmodel_curve;
        }
        clip: true;
        cacheBuffer: 20;
        delegate: Item {
            width: listview_curve.width;
            height: self.modeQuadratic ? 109 : 142;

            Rectangle {
                anchors.fill: parent;
                color: index == mouse_area.curve_index ? "#7FFFD4" : "#D3D3D3";
            }

            Text {
                anchors.left: parent.left;
                anchors.leftMargin: 20;
                anchors.verticalCenter: parent.verticalCenter;
                text: "编号_" + (index + 1);
                color: "#000000";
                font.pixelSize: 20;
            }

            /* 起点坐标 */
            Text {
                id: text_start_title;
                anchors.verticalCenter: input_start_x.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: (parent.width - (input_start_y.x + input_start_y.width - text_start_title.x)) / 2;
                text: qsTr("起点:");
                color: "#FF0000";
                font.pixelSize: 20;
            }

            XTextInput {
                id: input_start_x;
                anchors.left: text_start_title.left;
                anchors.leftMargin: 90;
                anchors.top: parent.top;
                anchors.topMargin: 5;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: start_x;
                inputTextColor: "#FF0000";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                onInputEditingFinished: function() {
                    var x = 0;
                    if (inputText.length > 0) {
                        x = parseInt(inputText);
                        if (isNaN(x)) {
                            x = 0;
                        }
                    }
                    start_x = x;
                    inputText = x.toString();
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].start_x = x;
                    } else {
                        canvas_cubic.list_curve[index].start_x = x;
                    }
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_start_x.inputText = start_x;
                        }
                    }
                }
            }

            XTextInput {
                id: input_start_y;
                anchors.left: input_start_x.right;
                anchors.leftMargin: 5;
                anchors.top: parent.top;
                anchors.topMargin: 5;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: start_y;
                inputTextColor: "#FF0000";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                onInputEditingFinished: function() {
                    var y = 0;
                    if (inputText.length > 0) {
                        y = parseInt(inputText);
                        if (isNaN(y)) {
                            y = 0;
                        }
                    }
                    start_y = y;
                    inputText = y.toString();
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].start_y = y;
                    } else {
                        canvas_cubic.list_curve[index].start_y = y;
                    }
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_start_y.inputText = start_y;
                        }
                    }
                }
            }

            /* 控制点1坐标 */
            Text {
                id: text_control_1_title
                anchors.verticalCenter: input_control_1_x.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: text_start_title.anchors.leftMargin;
                text: self.modeQuadratic ? qsTr("控制点:") : qsTr("控制点1:");
                color: "#006400";
                font.pixelSize: 20;
            }

            XTextInput {
                id: input_control_1_x;
                anchors.left: text_control_1_title.left;
                anchors.leftMargin: input_start_x.anchors.leftMargin;
                anchors.top: input_start_x.bottom;
                anchors.topMargin: 5;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: control_1_x;
                inputTextColor: "#006400";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                onInputEditingFinished: function() {
                    var x = 0;
                    if (inputText.length > 0) {
                        x = parseInt(inputText);
                        if (isNaN(x)) {
                            x = 0;
                        }
                    }
                    control_1_x = x;
                    inputText = x.toString();
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].control_1_x = x;
                    } else {
                        canvas_cubic.list_curve[index].control_1_x = x;
                    }
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_control_1_x.inputText = control_1_x;
                        }
                    }
                }
            }

            XTextInput {
                id: input_control_1_y;
                anchors.left: input_control_1_x.right;
                anchors.leftMargin: input_start_y.anchors.leftMargin;
                anchors.top: input_start_x.bottom;
                anchors.topMargin: input_control_1_x.anchors.topMargin;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: control_1_y;
                inputTextColor: "#006400";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                onInputEditingFinished: function() {
                    var y = 0;
                    if (inputText.length > 0) {
                        y = parseInt(inputText);
                        if (isNaN(y)) {
                            y = 0;
                        }
                    }
                    control_1_y = y;
                    inputText = y.toString();
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].control_1_y = y;
                    } else {
                        canvas_cubic.list_curve[index].control_1_y = y;
                    }
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_control_1_y.inputText = control_1_y;
                        }
                    }
                }
            }

            /* 控制点2坐标 */
            Text {
                id: text_control_2_title;
                anchors.verticalCenter: input_control_2_x.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: text_start_title.anchors.leftMargin;
                text: qsTr("控制点2:");
                color: "#00868B";
                font.pixelSize: 20;
                visible: self.modeQuadratic ? false : true;
            }

            XTextInput {
                id: input_control_2_x;
                anchors.left: text_control_2_title.left;
                anchors.leftMargin: input_start_x.anchors.leftMargin;
                anchors.top: input_control_1_x.bottom;
                anchors.topMargin: 5;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: control_2_x;
                inputTextColor: "#00868B";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                visible: self.modeQuadratic ? false : true;
                onInputEditingFinished: function() {
                    var x = 0;
                    if (inputText.length > 0) {
                        x = parseInt(inputText);
                        if (isNaN(x)) {
                            x = 0;
                        }
                    }
                    control_2_x = x;
                    inputText = x.toString();
                    canvas_cubic.list_curve[index].control_2_x = x;
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_control_2_x.inputText = control_2_x;
                        }
                    }
                }
            }

            XTextInput {
                id: input_control_2_y;
                anchors.left: input_control_2_x.right;
                anchors.leftMargin: input_control_1_y.anchors.leftMargin;
                anchors.top: input_control_1_x.bottom;
                anchors.topMargin: input_control_2_x.anchors.topMargin;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: control_2_y;
                inputTextColor: "#00868B";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                visible: self.modeQuadratic ? false : true;
                onInputEditingFinished: function() {
                    var y = 0;
                    if (inputText.length > 0) {
                        y = parseInt(inputText);
                        if (isNaN(y)) {
                            y = 0;
                        }
                    }
                    control_2_y = y;
                    inputText = y.toString();
                    canvas_cubic.list_curve[index].control_2_y = y;
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_control_2_y.inputText = control_2_y;
                        }
                    }
                }
            }

            /* 终点坐标 */
            Text {
                id: text_end_title;
                anchors.verticalCenter: input_end_x.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: text_start_title.anchors.leftMargin;
                text: qsTr("终点:");
                color: "#0000FF";
                font.pixelSize: 20;
            }

            XTextInput {
                id: input_end_x;
                anchors.left: text_end_title.left;
                anchors.leftMargin: input_start_x.anchors.leftMargin;
                anchors.top: self.modeQuadratic ? input_control_1_x.bottom : input_control_2_x.bottom;
                anchors.topMargin: 5;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: end_x;
                inputTextColor: "#0000FF";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                onInputEditingFinished: function() {
                    var x = 0;
                    if (inputText.length > 0) {
                        x = parseInt(inputText);
                        if (isNaN(x)) {
                            x = 0;
                        }
                    }
                    end_x = x;
                    inputText = x.toString();
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].end_x = x;
                    } else {
                        canvas_cubic.list_curve[index].end_x = x;
                    }
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_end_x.inputText = end_x;
                        }
                    }
                }
            }

            XTextInput {
                id: input_end_y;
                anchors.left: input_end_x.right;
                anchors.leftMargin: input_start_y.anchors.leftMargin;
                anchors.top: self.modeQuadratic ? input_control_1_x.bottom : input_control_2_x.bottom;
                anchors.topMargin: input_end_x.anchors.topMargin;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputText: end_y;
                inputTextColor: "#0000FF";
                inputFont.pixelSize: 20;
                hintText: "";
                width: 80;
                height: 28;
                onInputEditingFinished: function() {
                    var y = 0;
                    if (inputText.length > 0) {
                        y = parseInt(inputText);
                        if (isNaN(y)) {
                            y = 0;
                        }
                    }
                    end_y = y;
                    inputText = y.toString();
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].end_y = y;
                    } else {
                        canvas_cubic.list_curve[index].end_y = y;
                    }
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
                Timer {
                    interval: 100;
                    repeat: true;
                    running: true;
                    onTriggered: {
                        if (index === mouse_area.curve_index) {
                            parent.inputFocus = false;
                        }
                        if (!parent.inputFocus) {
                            input_end_y.inputText = end_y;
                        }
                    }
                }
            }

            XButton {
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                anchors.left: parent.left;
                anchors.leftMargin: 20;
                hint.text: "复制";
                hint.color: "#000000";
                hint.font.pixelSize: 18;
                width: 50;
                height: 26;
                onButtonClick: function() {
                    var pt = {
                        show: true,
                        debug: 1
                    };
                    if (self.modeQuadratic) {
                        var pt1 = canvas_quadratic.list_curve[index];
                        pt.start_x = pt1.start_x;
                        pt.start_y = pt1.start_y;
                        pt.control_1_x = pt1.control_1_x;
                        pt.control_1_y = pt1.control_1_y;
                        pt.control_2_x = pt1.control_2_x;
                        pt.control_2_y = pt1.control_2_y;
                        pt.end_x = pt1.end_x;
                        pt.end_y = pt1.end_y;
                        canvas_quadratic.list_curve.push(pt);
                    } else {
                        var pt2 = canvas_cubic.list_curve[index];
                        pt.start_x = pt2.start_x;
                        pt.start_y = pt2.start_y;
                        pt.control_1_x = pt2.control_1_x;
                        pt.control_1_y = pt2.control_1_y;
                        pt.control_2_x = pt2.control_2_x;
                        pt.control_2_y = pt2.control_2_y;
                        pt.end_x = pt2.end_x;
                        pt.end_y = pt2.end_y;
                        canvas_cubic.list_curve.push(pt);
                    }
                    listmodel_curve.append(pt);
                }
            }

            XButton {
                anchors.top: parent.top;
                anchors.topMargin: 5;
                anchors.right: parent.right;
                anchors.rightMargin: 30;
                hint.text: 1 === debug ? "调试1" : (2 === debug ? "调试2" : "调试关");
                hint.color: "#000000";
                hint.font.pixelSize: 18;
                width: 65;
                height: 26;
                onButtonClick: function() {
                    if (0 === debug) {
                        debug = 1;
                    } else if (1 === debug) {
                        debug = 2;
                    } else if (2 === debug) {
                        debug = 0;
                    }
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].debug = debug;
                    } else {
                        canvas_cubic.list_curve[index].debug = debug;
                    }
                }
            }

            XButton {
                anchors.verticalCenter: parent.verticalCenter;
                anchors.right: parent.right;
                anchors.rightMargin: 30;
                hint.text: show ? "隐藏" : "显示";
                hint.color: "#000000";
                hint.font.pixelSize: 18;
                width: 50;
                height: 26;
                onButtonClick: function() {
                    show = !show;
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve[index].show = show;
                    } else {
                        canvas_cubic.list_curve[index].show = show;
                    }
                }
            }

            XButton {
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                anchors.right: parent.right;
                anchors.rightMargin: 30;
                hint.text: "删除";
                hint.color: "#000000";
                hint.font.pixelSize: 18;
                width: 50;
                height: 26;
                onButtonClick: function() {
                    if (self.modeQuadratic) {
                        canvas_quadratic.list_curve.splice(index, 1);
                    } else {
                        canvas_cubic.list_curve.splice(index, 1);
                    }
                    listmodel_curve.remove(index);
                }
            }

            Rectangle {
                width: parent.width;
                height: 5;
                anchors.bottom: parent.bottom;
                color: "#F5F5F5";
            }
        }
    }

    /* 坐标编辑对话框框 */
    Popup {
        id: popup_edit_dialog;
        width: 260;
        height: 140;
        anchors.centerIn: parent;
        modal: true;
        closePolicy: Popup.NoAutoClose;
        property int debug: 0;
        property var editCallback: null;
        property var debugCallback: null;
        background: Rectangle {
            anchors.fill: parent;
            color: "white"
            radius: 5;

            Text {
                anchors.top: parent.top;
                anchors.topMargin: 10;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: "编辑坐标";
                color: "#000000";
                font.pixelSize: 20;
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
                id: text_edit_dialog_x;
                horizontalAlignment: Text.AlignLeft;
                verticalAlignment: Text.AlignVCenter;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: (parent.width - (width +
                                                    textinput_edit_dialog_x.anchors.leftMargin + textinput_edit_dialog_x.width +
                                                    text_edit_dialog_y.anchors.leftMargin + text_edit_dialog_y.width +
                                                    textinput_edit_dialog_y.anchors.leftMargin + textinput_edit_dialog_y.width)) / 2;
                text: "x:";
                color: "#000000";
                font.pixelSize: 18;
            }

            XTextInput {
                id: textinput_edit_dialog_x;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: text_edit_dialog_x.right;
                anchors.leftMargin: 5;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputTextColor: "#000000";
                inputFont.pixelSize: 18;
                hintText: "";
                width: 60;
                height: 28;
                onInputEditingFinished: function() {
                    var iNum = 0;
                    if (inputText.length > 0) {
                        iNum = parseInt(inputText);
                        if (isNaN(iNum)) {
                            iNum = 0;
                        }
                    }
                    inputText = iNum;
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
            }

            Text {
                id: text_edit_dialog_y;
                horizontalAlignment: Text.AlignLeft;
                verticalAlignment: Text.AlignVCenter;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: textinput_edit_dialog_x.right;
                anchors.leftMargin: 30;
                text: "y:";
                color: "#000000";
                font.pixelSize: 18;
            }

            XTextInput {
                id: textinput_edit_dialog_y;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: text_edit_dialog_y.right;
                anchors.leftMargin: 5;
                inputValidator: RegExpValidator {   /* 数字 */
                    regExp: /^(\-?)[0-9]{0,}$/;
                }
                inputTextColor: "#000000";
                inputFont.pixelSize: 18;
                hintText: "";
                width: 60;
                height: 28;
                onInputEditingFinished: function() {
                    var iNum = 0;
                    if (inputText.length > 0) {
                        iNum = parseInt(inputText);
                        if (isNaN(iNum)) {
                            iNum = 0;
                        }
                    }
                    inputText = iNum;
                }
                onInputAccepted: function() {
                    inputFocus = false;
                }
            }

            XButton {
                width: 50;
                height: 25;
                x: (parent.width / 2 - width / 2) / 2 - width / 2;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                hint.text: "修改";
                hint.color: "#000000";
                hint.font.pixelSize: 18;
                onButtonClick: function() {
                    popup_edit_dialog.close();
                    var tmpEditCB = popup_edit_dialog.editCallback;
                    popup_edit_dialog.editCallback = null;
                    if ('function' === typeof(tmpEditCB)) {
                        tmpEditCB(parseInt(textinput_edit_dialog_x.inputText), parseInt(textinput_edit_dialog_y.inputText));
                    }
                }
            }

            XButton {
                width: 60;
                height: 25;
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                hint.text: 1 === popup_edit_dialog.debug ? "调试1" : (2 === popup_edit_dialog.debug ? "调试2" : "调试关");
                hint.color: "#000000";
                hint.font.pixelSize: 18;
                onButtonClick: function() {
                    if (0 === popup_edit_dialog.debug) {
                        popup_edit_dialog.debug = 1;
                    } else if (1 === popup_edit_dialog.debug) {
                        popup_edit_dialog.debug = 2;
                    } else if (2 === popup_edit_dialog.debug) {
                        popup_edit_dialog.debug = 0;
                    }
                    if ('function' === typeof(popup_edit_dialog.debugCallback)) {
                        popup_edit_dialog.debugCallback(popup_edit_dialog.debug);
                    }
                }
            }

            XButton {
                width: 50;
                height: 25;
                x: parent.width / 2 + (parent.width / 2 - width / 2) / 2;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 10;
                hint.text: "关闭";
                hint.color: "#000000";
                hint.font.pixelSize: 18;
                onButtonClick: function() {
                    popup_edit_dialog.close();
                }
            }
        }
        function open(x, y, debugStatus, editCB, debugCB) {
            if (visible) {
                return;
            }
            visible = true;
            textinput_edit_dialog_x.inputText = x;
            textinput_edit_dialog_y.inputText = y;
            textinput_edit_dialog_x.inputFocus = false;
            textinput_edit_dialog_y.inputFocus = false;
            debug = debugStatus;
            editCallback = editCB;
            debugCallback = debugCB;
        }
    }

    Component.onCompleted: {
        updateSizeAndTitle();
        if (self.modeQuadratic) {
            listmodel_curve.clear();
            for (var i = 0; i < canvas_quadratic.list_curve.length; ++i) {
                listmodel_curve.append(canvas_quadratic.list_curve[i]);
            }
        } else {
            listmodel_curve.clear();
            for (var j = 0; j < canvas_cubic.list_curve.length; ++j) {
                listmodel_curve.append(canvas_cubic.list_curve[j]);
            }
        }
    }

    /* 更新窗口大小和标题 */
    function updateSizeAndTitle() {
        var title = "";
        if (self.modeQuadratic) {
            title = "二次贝塞尔曲线编辑器";
        } else {
            title = "三次贝塞尔曲线编辑器";
        }
        title += "_v1.1.0_何展然_坐标(" + proxy.getWindowX() + ", " + proxy.getWindowY() + ")";
        proxy.setWindowTitle(title);
        proxy.setWindowWidth(container.width + 10);
        proxy.setWindowHeight(container.height + (self.modeQuadratic ? 345 : 410));
    }
}
