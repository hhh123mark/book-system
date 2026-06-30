﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const mainImage = $('#mainImage');
  const galleryThumbs = $$('.book-gallery-thumb');
  const borrowBtn = $('#borrowBtn');
  const bookId = borrowBtn ? borrowBtn.dataset.bookId : null;

  if (galleryThumbs.length && mainImage) {
    galleryThumbs.forEach(thumb => {
      thumb.addEventListener('click', () => {
        const src = thumb.src;
        if (src) {
          mainImage.src = src;
          
          galleryThumbs.forEach(t => t.classList.remove('active'));
          thumb.classList.add('active');
        }
      });
    });
  }

  let currentIndex = 0;
  const images = Array.from(galleryThumbs).map(t => t.src);

  const prevBtn = $('#prevImage');
  const nextBtn = $('#nextImage');

  if (prevBtn && nextBtn && mainImage && images.length > 0) {
    prevBtn.addEventListener('click', () => {
      currentIndex = (currentIndex - 1 + images.length) % images.length;
      mainImage.src = images[currentIndex];
      galleryThumbs.forEach(t => t.classList.remove('active'));
      galleryThumbs[currentIndex]?.classList.add('active');
    });

    nextBtn.addEventListener('click', () => {
      currentIndex = (currentIndex + 1) % images.length;
      mainImage.src = images[currentIndex];
      galleryThumbs.forEach(t => t.classList.remove('active'));
      galleryThumbs[currentIndex]?.classList.add('active');
    });
  }

  let autoPlayTimer = null;
  const startAutoPlay = () => {
    if (images.length <= 1) return;
    autoPlayTimer = setInterval(() => {
      if (nextBtn) {
        nextBtn.click();
      }
    }, 5000);
  };

  const stopAutoPlay = () => {
    if (autoPlayTimer) {
      clearInterval(autoPlayTimer);
      autoPlayTimer = null;
    }
  };

  const galleryContainer = $('.book-gallery');
  if (galleryContainer && images.length > 1) {
    galleryContainer.addEventListener('mouseenter', stopAutoPlay);
    galleryContainer.addEventListener('mouseleave', startAutoPlay);
    startAutoPlay();
  }

  if (borrowBtn && bookId) {
    borrowBtn.addEventListener('click', async () => {
      const confirmed = await showConfirm(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ？ '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 30 '\u{0:x4}' -f [int]$args[0].Value 。', ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      if (!confirmed) return;

      setButtonLoading(borrowBtn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');

      try {
        const response = await ajax('/borrow', {
          method: 'POST',
          data: {
            action: 'borrow',
            bookId: bookId,
            days: 30
          }
        });

        if (response.success) {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'success');
          setTimeout(() => {
            window.location.href = '/borrow?action=list';
          }, 1500);
        } else {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
          setButtonLoading(borrowBtn, false);
        }
      } catch (e) {
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ， '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        setButtonLoading(borrowBtn, false);
      }
    });
  }

  const backBtn = $('#backBtn');
  if (backBtn) {
    backBtn.addEventListener('click', () => {
      if (document.referrer) {
        window.history.back();
      } else {
        window.location.href = '/book?action=list';
      }
    });
  }
});
