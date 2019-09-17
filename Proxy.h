/**********************************************************************
* Author:	jaron.ho
* Date:		2017-09-12
* Brief:	代理器,负责C++与QML的交互
**********************************************************************/
#ifndef _PROXY_H_
#define _PROXY_H_

#include <QDebug>
#include <QGuiApplication>
#include <QObject>
#include <QQuickWindow>
#include <QString>
#include <QVariant>
#include "XWindow.h"

class Proxy : public QObject {
    Q_OBJECT

private:
    /*
     * Brief:   单例模式,不允许外部实例化
     * Param:   void
     * Return:  void
     */
    Proxy(void) {}

public:
    /*
     * Brief:   调用QML函数接口
     * Param:   objectName - qml对象名
     *          methodName - 函数名
     *          retValue - 返回值(可为空指针)
     *          val0,val9 - 传入参数(最多支持9个参数)
     * Return:  bool
     */
    static bool callQml(QString objectName, QString methodName, QVariant* retValue,
                        QVariant val0 = QVariant(), QVariant val1 = QVariant(),
                        QVariant val2 = QVariant(), QVariant val3 = QVariant(),
                        QVariant val4 = QVariant(), QVariant val5 = QVariant(),
                        QVariant val6 = QVariant(), QVariant val7 = QVariant(),
                        QVariant val8 = QVariant(), QVariant val9 = QVariant());

    /*
     * Brief:   单例
     * Param:   void
     * Return:  Proxy*
     */
    static Proxy* getInstance(void);

public:
    /*
     * Brief:   初始化
     * Param:   void
     * Return:  void
     */
    void init(XWindow* win);

signals:

public slots:
    /* 获取本地文件内容 */
    QString getFileContent(QString filePath);

    /* 写入本地文件内容 */
    void writeFileContent(QString filePath, QString content);

    /* 窗口是否置顶 */
    bool isWindowOnTop(void);

    /* 设置窗口置顶 */
    void setWindowOnTop(bool flag);

    /* 获取窗口标题 */
    QString getWindowTitle(void);

    /* 设置窗口标题 */
    void setWindowTitle(QString title);

    /* 获取窗口X坐标 */
    int getWindowX(void);

    /* 设置窗口X坐标 */
    void setWindowX(int x);

    /* 获取窗口Y坐标 */
    int getWindowY(void);

    /* 设置窗口Y坐标 */
    void setWindowY(int y);

    /* 获取窗口宽 */
    int getWindowWidth(void);

    /* 设置窗口宽 */
    void setWindowWidth(int width);

    /* 获取窗口高 */
    int getWindowHeight(void);

    /* 设置窗口高 */
    void setWindowHeight(int height);

private:
    XWindow* mWin;
};

#endif // _PROXY_H_
