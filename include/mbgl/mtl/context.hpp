#pragma once

#include <mbgl/gfx/texture.hpp>
#include <mbgl/gfx/draw_mode.hpp>
#include <mbgl/gfx/depth_mode.hpp>
#include <mbgl/gfx/stencil_mode.hpp>
#include <mbgl/gfx/color_mode.hpp>
#include <mbgl/gfx/texture2d.hpp>
#include <mbgl/gfx/context.hpp>
#include <mbgl/mtl/buffer_resource.hpp>
#include <mbgl/mtl/mtl_fwd.hpp>
#include <mbgl/util/noncopyable.hpp>

#include <memory>
#include <optional>
#include <unordered_map>
#include <vector>

namespace mbgl {

class ProgramParameters;
class RenderStaticData;

namespace shaders {
struct ClipUBO;
} // namespace shaders

namespace mtl {

class RenderPass;
class RendererBackend;
class ShaderProgram;
class VertexBufferResource;

using UniqueShaderProgram = std::unique_ptr<ShaderProgram>;
using UniqueVertexBufferResource = std::unique_ptr<VertexBufferResource>;

class Context final : public gfx::Context {
public:
    Context(RendererBackend&);
    ~Context() noexcept override;
    Context(const Context&) = delete;
    Context& operator=(const Context& other) = delete;

    const RendererBackend& getBackend() const { return backend; }

    std::unique_ptr<gfx::CommandEncoder> createCommandEncoder() override;

    /// Create a new buffer object
    /// @param data The raw data to copy, may be `nullptr`
    /// @param size The size of the buffer
    /// @param usage Not currently used
    /// @param isIndexBuffer True if the buffer will be used for indexes.  The Metal API only accepts `MTLBuffer`
    /// objects for drawing indexed primitives, so this constrains how the buffer can be managed.
    /// @param persistent Performance hint, assume this buffer will be reused many times.
    BufferResource createBuffer(
        const void* data, std::size_t size, gfx::BufferUsageType usage, bool isIndexBuffer, bool persistent) const;

    UniqueShaderProgram createProgram(std::string name,
                                      std::string_view source,
                                      std::string_view vertexName,
                                      std::string_view fragmentName,
                                      const ProgramParameters& programParameters,
                                      const std::unordered_map<std::string, std::string>& additionalDefines);

    MTLTexturePtr createMetalTexture(MTLTextureDescriptorPtr textureDescriptor) const;
    MTLSamplerStatePtr createMetalSamplerState(MTLSamplerDescriptorPtr samplerDescriptor) const;

    void clear();

    // Actually remove the objects we marked as abandoned with the above methods.
    void performCleanup() override;

    void reduceMemoryUsage() override {}

    gfx::UniqueDrawableBuilder createDrawableBuilder(std::string name) override;
    gfx::UniformBufferPtr createUniformBuffer(const void* data, std::size_t size, bool persistent) override;

    gfx::ShaderProgramBasePtr getGenericShader(gfx::ShaderRegistry&, const std::string& name) override;

    TileLayerGroupPtr createTileLayerGroup(int32_t layerIndex, std::size_t initialCapacity, std::string name) override;

    LayerGroupPtr createLayerGroup(int32_t layerIndex, std::size_t initialCapacity, std::string name) override;

    gfx::Texture2DPtr createTexture2D() override;

    RenderTargetPtr createRenderTarget(const Size size, const gfx::TextureChannelDataType type) override;

    // UniqueFramebuffer createFramebuffer(const gfx::Texture2D& color);

    void resetState(gfx::DepthMode depthMode, gfx::ColorMode colorMode) override;

    void setDirtyState() override;

    std::unique_ptr<gfx::OffscreenTexture> createOffscreenTexture(Size, gfx::TextureChannelDataType, bool, bool);

    std::unique_ptr<gfx::OffscreenTexture> createOffscreenTexture(Size, gfx::TextureChannelDataType) override;

    std::unique_ptr<gfx::TextureResource> createTextureResource(Size,
                                                                gfx::TexturePixelType,
                                                                gfx::TextureChannelDataType) override;

    std::unique_ptr<gfx::RenderbufferResource> createRenderbufferResource(gfx::RenderbufferPixelType,
                                                                          Size size) override;

    std::unique_ptr<gfx::DrawScopeResource> createDrawScopeResource() override;

#if !defined(NDEBUG)
    void visualizeStencilBuffer() override;
    void visualizeDepthBuffer(float depthRangeSize) override;
#endif

    void clearStencilBuffer(int32_t) override;

    MTLDepthStencilStatePtr makeDepthStencilState(const gfx::DepthMode&,
                                                  const gfx::StencilMode&,
                                                  const gfx::Renderable&) const;

    virtual bool emplaceOrUpdateUniformBuffer(gfx::UniformBufferPtr&,
                                              const void* data,
                                              std::size_t size,
                                              bool persistent);

    /// Get a reusable buffer containing the standard fixed tile vertices (+/- `util::EXTENT`)
    const BufferResource& getTileVertexBuffer();

    /// Get a reusable buffer containing the standard fixed tile indexes
    const BufferResource& getTileIndexBuffer();

    /// Get a buffer to be bound to unused vertex buffers
    const UniqueVertexBufferResource& getEmptyVertexBuffer();

    bool renderTileClippingMasks(gfx::RenderPass& renderPass,
                                 RenderStaticData& staticData,
                                 const std::vector<shaders::ClipUBO>& tileUBOs);

private:
    RendererBackend& backend;
    bool cleanupOnDestruction = true;

    std::optional<BufferResource> tileVertexBuffer;
    std::optional<BufferResource> tileIndexBuffer;

    UniqueVertexBufferResource emptyVertexBuffer;

    gfx::ShaderProgramBasePtr clipMaskShader;
    MTLDepthStencilStatePtr clipMaskDepthStencilState;
    MTLRenderPipelineStatePtr clipMaskPipelineState;
    std::optional<BufferResource> clipMaskUniformsBuffer;
    bool clipMaskUniformsBufferUsed = false;
    const gfx::Renderable* stencilStateRenderable = nullptr;
};

} // namespace mtl
} // namespace mbgl