#include <mbgl/util/platform.hpp>
#include <mbgl/platform/thread.hpp>

#include <string>

#include <QDebug>

namespace mbgl {
namespace platform {

std::string getCurrentThreadName() {
    return "unknown";
}

void setCurrentThreadName(const std::string &name) {
    qDebug() << "Thread: " << name;
}

void makeThreadLowPriority() {}

void setCurrentThreadPriority(double) {}

void attachThread() {}

void detachThread() {}

} // namespace platform
} // namespace mbgl
