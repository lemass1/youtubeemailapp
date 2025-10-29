import React, { useEffect, useRef } from "react";
import "./videos_assets/css/main.css";
import "./videos_assets/css/fontawesome-all.min.css";
import "./videos_assets/css/noscript.css";
import "./videos_assets/css/videos-custom.css";

function Videos() {
  const carouselRef = useRef(null);

  useEffect(() => {
    document.body.classList.remove("is-preload");
  }, []);

  const videos = [
    { id: 1, title: "Video 1", src: "https://www.youtube.com/embed/1SyNgHDKVuY" },
    { id: 2, title: "Video 2", src: "https://www.youtube.com/embed/xP0YHYbhFtI" },
    { id: 3, title: "Video 3", src: "https://www.youtube.com/embed/SU3XxqAFDI8" },
    { id: 4, title: "Video 4", src: "https://www.youtube.com/embed/pwBL98WKPvQ" },
    { id: 5, title: "Video 5", src: "https://www.youtube.com/embed/5UYoamIogcU" },
    { id: 6, title: "Video 6", src: "https://www.youtube.com/embed/PDeXrAuChaM" },
    { id: 7, title: "Video 7", src: "https://www.youtube.com/embed/eUiH6DKEFLo" },
    { id: 8, title: "Video 8", src: "https://www.youtube.com/embed/zG1NIxThkdk" },
    { id: 9, title: "Video 9", src: "https://www.youtube.com/embed/pgHWYV7WYc0" },
    { id: 10, title: "Video 10", src: "https://www.youtube.com/embed/70tdhSpwt2Q" },
    { id: 11, title: "Video 11", src: "https://www.youtube.com/embed/nnO-WTh7VIY" },
    { id: 12, title: "Video 12", src: "https://www.youtube.com/embed/rNZRYPEiYNg" },
  ];

  const scrollLeft = () => carouselRef.current.scrollBy({ left: -350, behavior: "smooth" });
  const scrollRight = () => carouselRef.current.scrollBy({ left: 350, behavior: "smooth" });

  return (
    <div id="wrapper">
      <div id="bg"></div>
      <div id="overlay"></div>

      <div id="main">
        {/* Header/Intro + Carousel directly below text */}
        <header id="header" className="videos-header">
          <h1>Jeremiah3122 Ministry</h1>
          <div className="videos-intro-text">
            <p>
              “On this channel, God has chosen His messengers to bring His
              message to His people.”
            </p>
            <p>
              If you like our channel, share, comment, and be a part — you can
              always visit for more good news.
            </p>
          </div>

          {/* Carousel moved inside header for tighter layout */}
          <div className="videos-carousel-container">
            <button className="scroll-btn left" onClick={scrollLeft}>
              ‹
            </button>
            <div className="videos-carousel" ref={carouselRef}>
              {videos.map((video) => (
                <article key={video.id} className="video-card">
                  <h2>{video.title}</h2>
                  <div className="video-thumb">
                    <iframe
                      width="100%"
                      height="200"
                      src={video.src}
                      title={video.title}
                      frameBorder="0"
                      allowFullScreen
                    ></iframe>
                  </div>
                </article>
              ))}
            </div>
            <button className="scroll-btn right" onClick={scrollRight}>
              ›
            </button>
          </div>
        </header>

        {/* Footer stays unchanged */}
        <footer id="footer">
          <section>
            <p>
              This is <strong>Parallelism</strong>, adapted for{" "}
              <strong>Jeremiah3122 Ministry</strong>. Original design by{" "}
              <a href="http://html5up.net">HTML5 UP</a>.
            </p>
          </section>
        </footer>
      </div>
    </div>
  );
}

export default Videos;
