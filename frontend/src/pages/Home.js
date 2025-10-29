import React, { useEffect } from "react";
import { Link } from "react-router-dom";
import "./assets/css/main.css";
import "./assets/css/fontawesome-all.min.css";
import "./assets/css/noscript.css";

function Home() {
  useEffect(() => {
    // mimic HTML5 UP preload removal
    document.body.classList.remove("is-preload");
  }, []);

  return (
    <div id="wrapper">
      <div id="bg"></div>
      <div id="overlay"></div>

      <div id="main">
        {/* Header */}
        <header id="header">
          <h1>Jeremiah3122 Ministry</h1>
          <p>“The Lord has created a new thing in the earth.”</p>
          <p>
            This is a prophecy that is coming into effect — the new beginning of
            True Christianity.
          </p>

          <h2>Luke 9:1–2 (KJV)</h2>
          <p>
            [1] Then he called his twelve disciples together, and gave them
            power and authority over all devils, and to cure diseases.
          </p>
          <p>
            [2] And he sent them to preach the kingdom of God, and to heal the
            sick.
          </p>

          {/* Navigation Buttons */}
          <nav>
            <ul>
              <li>
                <Link
                  to="/videos"
                  className="icon brands fa-youtube"
                  title="Videos"
                >
                  <span className="label">Videos</span>
                </Link>
              </li>
              <li>
                <Link
                  to="/contact"
                  className="icon solid fa-envelope"
                  title="Contact"
                >
                  <span className="label">Contact</span>
                </Link>
              </li>
            </ul>
          </nav>
        </header>

        {/* Footer */}
        <footer id="footer">
          <span className="copyright">
            &copy; {new Date().getFullYear()} Jeremiah3122 Ministry. Design
            inspired by <a href="http://html5up.net">HTML5 UP</a>.
          </span>
        </footer>
      </div>
    </div>
  );
}

export default Home;
