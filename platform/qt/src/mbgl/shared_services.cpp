#include <QtNetwork/qnetworkrequest.h>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>

#include "http_file_source.hpp"
#include "shared_services.hpp"

namespace mbgl {
namespace platform {

void QtNetworkManager::request(QNetworkRequest request) {
    qDebug() << "Received!" << request.url();

    QNetworkReply *reply = this->get(QNetworkRequest(request.url()));
    connect(reply, &QNetworkReply::finished, this, &QtNetworkManager::response);
#if QT_VERSION >= QT_VERSION_CHECK(5, 15, 0)
    connect(reply, &QNetworkReply::errorOccurred, this, &QtNetworkManager::response);
#else
    connect(reply, &QNetworkReply::error, this, &QtNetworkManager::response);
#endif

    m_pending.insert(reply, request.url());

    qDebug() << reply << request.url() << reply->request().url() << m_pending[reply];
}

void QtNetworkManager::response() {
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    qDebug() << "MGR response:" << reply;
    for (auto it = m_pending.begin(); it != m_pending.end(); ++it) {
        qDebug() << "MGR pending:" << it.key() << it.value();
    }

    if (!m_pending.contains(reply)) {
        return;
    }

    const QUrl &url = m_pending[reply];

    QByteArray data = reply->readAll();

    qDebug() << "MGR done:" << url;

    // qDebug() << "MGR data:" << data;

    emit result(url, data);

    m_pending.remove(reply);
}

} // namespace platform
} // namespace mbgl
