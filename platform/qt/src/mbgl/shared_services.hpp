#pragma once

#include <QtNetwork/qnetworkrequest.h>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>

#if !defined(QT_MAPLIBRE_STATIC)
#if defined(QT_BUILD_MAPLIBRE_LIB)
#define Q_MAPLIBRE_EXPORT Q_DECL_EXPORT
#else
#define Q_MAPLIBRE_EXPORT Q_DECL_IMPORT
#endif
#else
#define Q_MAPLIBRE_EXPORT
#endif

namespace mbgl {
namespace platform {

class Q_MAPLIBRE_EXPORT QtNetworkManager : public QNetworkAccessManager {
    Q_OBJECT
public:
    explicit QtNetworkManager(QObject *parent = nullptr)
        : QNetworkAccessManager(parent) {}

signals:
    void result(QUrl, QByteArray);

public slots:
    void request(QNetworkRequest request);
    void response();

private:
    QMap<QNetworkReply *, QUrl> m_pending;
};

class QtServices {
public:
    static QtServices &getInstance() {
        static QtServices instance; // Guaranteed to be destroyed.
                                    // Instantiated on first use.
        return instance;
    }

    [[nodiscard]] inline QtNetworkManager *networkManager() const { return _networkManager; }
    void setNetworkManager(QtNetworkManager *manager) { _networkManager = manager; }

private:
    QtServices() = default;
    ~QtServices() = default;

public:
    QtServices(QtServices const &) = delete;
    void operator=(QtServices const &) = delete;

private:
    QtNetworkManager *_networkManager{};
};

} // namespace platform
} // namespace mbgl
