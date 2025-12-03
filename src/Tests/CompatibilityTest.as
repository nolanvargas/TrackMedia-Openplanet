namespace CompatibilityTest
{
    class TestResult
    {
        string name;
        string url;
        string status; // "Pending", "Loading", "Success", "Error"
        string errorMessage;
        UI::Texture@ texture;
        int responseCode;
        uint64 downloadSize;
        uint64 textureSize;
        uint64 loadTimeMs;

        TestResult(const string &in u)
        {
            url = u;
            // Extract name from URL (last part)
            auto parts = url.Split("/");
            if (parts.Length > 0) {
                name = parts[parts.Length - 1];
            } else {
                name = url;
            }
            status = "Pending";
        }
    }

    array<TestResult@> results;
    bool isRunning = false;

    void Start()
    {
        if (isRunning) return;
        
        results.Resize(0);
        
        // Add URLs
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/AVIF.avif"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/WMP.wmp"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/WEBP.webp"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/WDP.wdp"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/TIFF.tif"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/TARGA.tga"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/SVG.svg"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/RLE.rle"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/PNG.png"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/PDN.pdn"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/PDF.pdf"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/JXR.jxr"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/JXL.jxl"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/JPEG.jpg"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/JPE.jpe"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/JFIF.jfif"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/ICO.ico"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/GIF.gif"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/EXIF.exif"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/DIB.dib"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/DDS.dds"));
        results.InsertLast(TestResult("https://download.dashmap.live/19f5720e-a9ae-4d40-b3e3-cbf1bceecd5f/BMP.bmp"));

        isRunning = true;
        startnew(RunTests);
    }

    void RunTests()
    {
        for (uint i = 0; i < results.Length; i++) {
            TestResult@ res = results[i];
            res.status = "Loading";
            
            uint64 startTime = Time::Now;
            
            auto req = Net::HttpGet(res.url);
            req.Start();
            while (!req.Finished()) {
                yield();
            }
            
            res.loadTimeMs = Time::Now - startTime;
            res.responseCode = req.ResponseCode();
            res.downloadSize = req.Buffer().GetSize();
            
            if (res.responseCode == 200) {
                try {
                    @res.texture = UI::LoadTexture(req.Buffer());
                    if (res.texture !is null) {
                        res.status = "Success";
                        vec2 size = res.texture.GetSize();
                        res.textureSize = uint64(size.x * size.y * 4); // Approx 4 bytes per pixel (RGBA)
                    } else {
                        res.status = "Error";
                        res.errorMessage = "Failed to create texture from buffer";
                    }
                } catch {
                    res.status = "Error";
                    res.errorMessage = "Exception loading texture: " + getExceptionInfo();
                }
            } else {
                res.status = "Error";
                res.errorMessage = "HTTP " + res.responseCode;
            }
        }
        isRunning = false;
    }
}
