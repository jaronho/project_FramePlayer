#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "XWindow.h"
#include "Proxy.h"

int main(int argc, char *argv[]) {
    QCoreApplication::setApplicationName("Qt");
    QCoreApplication::setOrganizationName("Qt");
    QCoreApplication::setOrganizationDomain("www.qt.io");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    XWindow window(QSize(480, 585), QSize(480, 585), QSize(480, 585));
    Proxy::getInstance()->init(&window);
    window.setFlag(Qt::Window, true);
    window.setFlag(Qt::WindowTitleHint, true);
    window.setFlag(Qt::WindowSystemMenuHint, true);
    window.setFlag(Qt::WindowMinMaxButtonsHint, true);
    window.setFlag(Qt::WindowStaysOnTopHint, false);
    window.setFlag(Qt::WindowCloseButtonHint, true);
    window.setContextProperty("proxy", Proxy::getInstance());
    window.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    window.show();
    return app.exec();
}
