/**********************************************************************
* Author:	jaron.ho
* Date:		2017-09-12
* Brief:	代理器,负责C++与QML的交互
**********************************************************************/
#include "Proxy.h"
#include <QFile>

bool Proxy::callQml(QString objectName, QString methodName, QVariant* retValue,
                    QVariant val0, QVariant val1,
                    QVariant val2, QVariant val3,
                    QVariant val4, QVariant val5,
                    QVariant val6, QVariant val7,
                    QVariant val8, QVariant val9) {
    if (QGuiApplication::allWindows().isEmpty()) {
        return false;
    }
    QObject* obj = QGuiApplication::allWindows()[0]->findChild<QObject*>(objectName, Qt::FindChildrenRecursively);
    if (!obj) {
        return false;
    }
    return QMetaObject::invokeMethod(obj, methodName.toUtf8(), Qt::AutoConnection,
                                     retValue ? Q_RETURN_ARG(QVariant, *retValue) : QGenericReturnArgument(),
                                     val0.isValid() ? Q_ARG(QVariant, val0) : QGenericArgument(),
                                     val1.isValid() ? Q_ARG(QVariant, val1) : QGenericArgument(),
                                     val2.isValid() ? Q_ARG(QVariant, val2) : QGenericArgument(),
                                     val3.isValid() ? Q_ARG(QVariant, val3) : QGenericArgument(),
                                     val4.isValid() ? Q_ARG(QVariant, val4) : QGenericArgument(),
                                     val5.isValid() ? Q_ARG(QVariant, val5) : QGenericArgument(),
                                     val6.isValid() ? Q_ARG(QVariant, val6) : QGenericArgument(),
                                     val7.isValid() ? Q_ARG(QVariant, val7) : QGenericArgument(),
                                     val8.isValid() ? Q_ARG(QVariant, val8) : QGenericArgument(),
                                     val9.isValid() ? Q_ARG(QVariant, val9) : QGenericArgument());
}

Proxy* Proxy::getInstance(void) {
    static Proxy* instance = nullptr;
    if (nullptr == instance) {
        instance = new Proxy();
    }
    return instance;
}

void Proxy::init(XWindow* win) {
    mWin = win;
}

QString Proxy::getFileContent(QString filePath) {
    if (filePath.isEmpty()) {
        return "";
    }
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        return "";
    }
    QString content = file.readAll();
    file.close();
    return content;
}

void Proxy::writeFileContent(QString filePath, QString content) {
    if (filePath.isEmpty()) {
        return;
    }
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly)) {
        return;
    }
    QTextStream fileStream(&file);
    fileStream << content;
    file.flush();
    file.close();
}

bool Proxy::isWindowOnTop(void) {
    if (mWin) {
        return (Qt::WindowStaysOnTopHint & mWin->getView()->flags()) > 0;
    }
    return false;
}

void Proxy::setWindowOnTop(bool flag) {
    if (mWin) {
        mWin->setFlag(Qt::WindowStaysOnTopHint, flag);
    }
}

QString Proxy::getWindowTitle(void) {
    if (mWin) {
        return mWin->getView()->title();
    }
    return "";
}

void Proxy::setWindowTitle(QString title) {
    if (mWin) {
        mWin->getView()->setTitle(title);
    }
}

int Proxy::getWindowX(void) {
    if (mWin) {
        return mWin->getView()->x();
    }
    return 0;
}

void Proxy::setWindowX(int x) {
    if (mWin) {
        mWin->getView()->setX(x);
    }
}

int Proxy::getWindowY(void) {
    if (mWin) {
        return mWin->getView()->y();
    }
    return 0;
}

void Proxy::setWindowY(int y) {
    if (mWin) {
        mWin->getView()->setY(y);
    }
}

int Proxy::getWindowWidth(void) {
    if (mWin) {
        return mWin->getView()->width();
    }
    return 0;
}

void Proxy::setWindowWidth(int width) {
    if (mWin) {
        mWin->getView()->setMinimumWidth(width);
        mWin->getView()->setMaximumWidth(width);
        mWin->getView()->setWidth(width);
    }
}

int Proxy::getWindowHeight(void) {
    if (mWin) {
        return mWin->getView()->height();
    }
    return 0;
}

void Proxy::setWindowHeight(int height) {
    if (mWin) {
        mWin->getView()->setMinimumHeight(height);
        mWin->getView()->setMaximumHeight(height);
        mWin->getView()->setHeight(height);
    }
}
