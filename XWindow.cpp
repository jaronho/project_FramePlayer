#include "XWindow.h"
#include <QQmlContext>
#include <QQuickItem>

XWindow::XQuickView::XQuickView(QWindow* parent) : QQuickView(parent) {
    mIsDragging = false;
    mDraggable = true;
}

void XWindow::XQuickView::setDraggable(bool on) {
    mDraggable = on;
}

void XWindow::XQuickView::resizeEvent(QResizeEvent* event) {
    QQuickView::resizeEvent(event);
}

void XWindow::XQuickView::mousePressEvent(QMouseEvent* event) {
    if (Qt::LeftButton == event->button()) {
        mIsDragging = true;
        mDragPosition = event->pos();
    }
    QQuickView::mousePressEvent(event);
}

void XWindow::XQuickView::mouseReleaseEvent(QMouseEvent* event) {
    if (Qt::LeftButton == event->button()) {
        mIsDragging = false;
    }
    QQuickView::mouseReleaseEvent(event);
}

void XWindow::XQuickView::mouseMoveEvent(QMouseEvent* event) {
    if (mIsDragging && mDraggable) {
        setPosition(event->globalPos() - mDragPosition);
    }
    QQuickView::mouseMoveEvent(event);
}

XWindow::XWindow(const QSize& size, const QSize& minimumSize, const QSize& maximumSize, bool draggable) {
    mView = new XQuickView();
    mView->setColor(QColor(Qt::transparent));
    if (size.width() > 0 && size.height() > 0) {
        mView->setResizeMode(QQuickView::ResizeMode::SizeRootObjectToView);
        mView->resize(size);
    }
    if (minimumSize.width() > 0 && minimumSize.height() > 0) {
        int minimumWidth = minimumSize.width() < size.width() ? minimumSize.width() : size.width();
        int minimumHeight = minimumSize.height() < size.height() ? minimumSize.height() : size.height();
        mView->setMinimumSize(QSize(minimumWidth, minimumHeight));
    }
    if (maximumSize.width() > 0 && maximumSize.height() > 0) {
        int maximumWidth = maximumSize.width() > size.width() ? maximumSize.width() : size.width();
        int maximumHeight = maximumSize.height() > size.height() ? maximumSize.height() : size.height();
        mView->setMaximumSize(QSize(maximumWidth, maximumHeight));
    }
    mView->setDraggable(draggable);
}

XWindow::~XWindow(void) {
    delete mView;
}

XWindow::XQuickView* XWindow::getView(void) {
    return mView;
}

void XWindow::setFlags(Qt::WindowFlags flags) {
    mView->setFlags(flags);
}

void XWindow::setFlag(Qt::WindowType flag, bool on) {
    mView->setFlag(flag, on);
}

void XWindow::setContextProperty(const QString& name, QObject* value) {
    mView->rootContext()->setContextProperty(name, value);
}

void XWindow::setContextProperty(const QString& name, const QVariant& value) {
    mView->rootContext()->setContextProperty(name, value);
}

void XWindow::setTitle(QString title) {
    mView->setTitle(title);
}

void XWindow::setIcon(QIcon icon) {
    mView->setIcon(icon);
}

void XWindow::setSource(const QUrl& source) {
    mView->setSource(source);
}

void XWindow::show(void) {
    mView->show();
}

void XWindow::hide(void) {
    mView->hide();
}

void XWindow::showFullScreen(void) {
    mView->showFullScreen();
}

void XWindow::showMaximized(void) {
    mView->showMaximized();
}

void XWindow::showMinimized(void) {
    mView->showMinimized();
}

void XWindow::showNormal(void) {
    mView->showNormal();
}

void XWindow::close(void) {
    mView->close();
}
