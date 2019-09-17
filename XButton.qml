import QtQuick 2.9

Item {
    property alias radius: frame.radius;                            /* 按钮四个角弧度 */
    property color backgroundColorNormal: "#ebebeb";                /* 按钮常态时背景颜色 */
    property color backgroundColorHover: "#d9f0fc";                 /* 鼠标移到按钮上时背景颜色 */
    property color backgroundColorPress: "#c4e5f6";                 /* 鼠标按下时按钮背景颜色 */
    property int borderWidth: 1;                                    /* 边框宽度 */
    property color borderColorNormal: "#707070";                    /* 按钮常态边框颜色 */
    property color borderColorHover: "#3c7fb1";                     /* 鼠标移到按钮上时边框颜色 */
    property color borderColorPress: "#2c5a8c";                     /* 鼠标按下时按钮边框颜色 */
    property string imageSourceNormal: "";                          /* 按钮常态时图片资源 */
    property string imageSourceHover: "";                           /* 鼠标移到按钮上时图片资源 */
    property string imageSourcePress: "";                           /* 鼠标按下时按钮图片资源 */
    property alias hint: hint;                                      /* 按钮文本 */
    property var onButtonEnter: null;                               /* 鼠标移到按钮上的回调函数 */
    property var onButtonExit: null;                                /* 鼠标离开按钮上的回调函数 */
    property var onButtonPress: null;                               /* 鼠标按下时的回调函数 */
    property var onButtonRelease: null;                             /* 鼠标释放时的回调函数 */
    property var onButtonClick: null;                               /* 鼠标点击时的回调函数 */
    property int mouseLeftMargin: 0;                                /* 鼠标触发左边距 */
    property int mouseTopMargin: 0;                                 /* 鼠标触发上边距 */
    property int mouseRightMargin: 0;                               /* 鼠标触发右边距 */
    property int mouseBottomMargin: 0;                              /* 鼠标触发下边距 */
    property bool hovered: self.isMouseHover;

    width: 50;
    height: 20;

    /* 私有属性 */
    QtObject {
        id: self;
        property bool isMouseHover;
        property bool isMousePress;

        function getBackgroundColor() {
            if (isMousePress) {
                return isMouseHover ? backgroundColorPress : backgroundColorHover;
            }
            return isMouseHover ? backgroundColorHover : backgroundColorNormal;
        }

        function getBorderColor() {
            if (isMousePress) {
                return isMouseHover ? borderColorPress : borderColorHover;
            }
            return isMouseHover ? borderColorHover : borderColorNormal;
        }

        function getImageSource() {
            if (0 === imageSourcePress.length) {
                if (0 === imageSourceHover.length) {
                    imageSourcePress = imageSourceNormal;
                } else {
                    imageSourcePress = imageSourceHover;
                }
            }
            if (0 === imageSourceHover.length) {
                if (0 === imageSourcePress.length) {
                    imageSourceHover = imageSourceNormal;
                } else {
                    imageSourceHover = imageSourcePress;
                }
            }
            if (isMousePress) {
                return isMouseHover ? imageSourcePress : imageSourceHover;
            }
            return isMouseHover ? imageSourceHover : imageSourceNormal;
        }
    }

    /* 背景框 */
    Rectangle {
        id: frame;
        anchors.fill: parent;
        color: self.getBackgroundColor();
        border.width: borderWidth;
        border.color: self.getBorderColor();
        radius: 4;
    }

    /* 背景图片 */
    Image {
        id: image;
        anchors.fill: parent;
        source: self.getImageSource();
    }

    /* 文本 */
    Text {
        id: hint;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.verticalCenter: parent.verticalCenter;
        font.pixelSize: frame.height * 0.7;
        color: "#000000";
        opacity: 1;
    }

    /* 鼠标事件 */
    MouseArea {
        anchors.left: parent.left;
        anchors.leftMargin: mouseLeftMargin;
        anchors.top: parent.top;
        anchors.topMargin: mouseTopMargin;
        anchors.right: parent.right;
        anchors.rightMargin: mouseRightMargin;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: mouseBottomMargin;
        hoverEnabled: true;
        enabled: parent.enabled;
        onEntered: {
            self.isMouseHover = true;
            if ('function' === typeof(onButtonEnter)) {
                onButtonEnter();
            }
        }
        onExited: {
            self.isMouseHover = false;
            if ('function' === typeof(onButtonExit)) {
                onButtonExit();
            }
        }
        onPressed: {
            self.isMousePress = true;
            if ('function' === typeof(onButtonPress)) {
                onButtonPress();
            }
        }
        onReleased: {
            self.isMousePress = false;
            if ('function' === typeof(onButtonRelease)) {
                onButtonRelease();
            }
        }
        onClicked: {
            if ('function' === typeof(onButtonClick)) {
                onButtonClick();
            }
        }
    }
}
