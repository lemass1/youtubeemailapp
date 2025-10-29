import React, { useState, useEffect } from "react";
import "./videos_assets/css/main.css";
import "./videos_assets/css/fontawesome-all.min.css";
import "./videos_assets/css/noscript.css";
import "./videos_assets/css/videos-custom.css";
import contactHeaderImg from "./videos_assets/css/images/contact-header.jpg";

function Contact() {
  const [formData, setFormData] = useState({ name: "", email: "", message: "" });
  const [status, setStatus] = useState("");
  const [verse, setVerse] = useState(null);
  const [loadingVerse, setLoadingVerse] = useState(true);

  // Fetch daily devotional verse
  useEffect(() => {
    const fetchVerse = async () => {
      try {
        const res = await fetch("https://beta.ourmanna.com/api/v1/get/?format=json");
        const data = await res.json();
        if (data?.verse?.details) {
          setVerse({
            text: data.verse.details.text,
            reference: data.verse.details.reference,
          });
        }
      } catch (error) {
        console.error("Error fetching verse:", error);
        setVerse({
          text: "“The grass withers, the flower fades, but the word of our God will stand forever.”",
          reference: "Isaiah 40:8",
        });
      } finally {
        setLoadingVerse(false);
      }
    };
    fetchVerse();
  }, []);

  const handleChange = (e) =>
    setFormData({ ...formData, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const res = await fetch("/api/sendEmail", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      if (res.ok) {
        setStatus("✅ Message sent successfully!");
        setFormData({ name: "", email: "", message: "" });
      } else {
        setStatus("❌ Failed to send message. Please try again later.");
      }
    } catch (err) {
      setStatus("⚠️ Error sending message.");
    }
  };

  return (
    <div id="wrapper">
      <div id="bg"></div>
      <div id="overlay"></div>

      <div id="main">
        {/* Header */}
        <header id="header" className="videos-header">
          <img
            src={contactHeaderImg}
            alt="Jeremiah3122 Ministry Contact"
            className="contact-header-img"
          />
          <h1>Contact Jeremiah3122 Ministry</h1>
          <p>“Let everything you do be done in love.” — 1 Corinthians 16:14</p>
        </header>

        {/* Daily Devotional Section — now directly under header */}
        <section className="devotional-section-light fade-in">
          <h2>📖 Daily Devotional</h2>
          {loadingVerse ? (
            <p>Loading today’s verse...</p>
          ) : verse ? (
            <blockquote className="devotional-verse-light">
              “{verse.text}”
              <footer>— {verse.reference}</footer>
            </blockquote>
          ) : (
            <p>Unable to load verse today.</p>
          )}
          <p className="devotional-message">
            May this verse strengthen your faith today. Keep walking in His word.
          </p>
        </section>

        {/* Contact Form Section */}
        <section className="contact-section fade-in">
          <h2>Send Us a Message</h2>
          <form className="contact-form" onSubmit={handleSubmit}>
            <div className="form-group">
              <input
                type="text"
                name="name"
                placeholder="Your Name"
                value={formData.name}
                onChange={handleChange}
                required
              />
            </div>
            <div className="form-group">
              <input
                type="email"
                name="email"
                placeholder="Your Email"
                value={formData.email}
                onChange={handleChange}
                required
              />
            </div>
            <div className="form-group">
              <textarea
                name="message"
                placeholder="Your Message"
                value={formData.message}
                onChange={handleChange}
                required
              ></textarea>
            </div>
            <button type="submit" className="send-btn">
              Send Message
            </button>
          </form>
          {status && <p className="status-message">{status}</p>}
        </section>

        {/* Footer */}
        <footer id="footer">
          <section>
            <p>
              &copy; {new Date().getFullYear()} Jeremiah3122 Ministry. Design
              inspired by <a href="http://html5up.net">HTML5 UP</a>.
            </p>
          </section>
        </footer>
      </div>
    </div>
  );
}

export default Contact;
