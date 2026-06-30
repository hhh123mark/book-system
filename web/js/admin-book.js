﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const bookForm = $('#bookForm');
  const searchForm = $('#searchForm');
  const coverUpload = $('#coverUpload');
  const coverInput = $('#coverInput');
  const coverPreview = $('#coverPreview');
  const coverPath = $('#coverPath');
  const addImageBtn = $('#addImageBtn');
  const imagesContainer = $('#imagesContainer');
  const submitBtn = $('#submitBtn');

  const getCurrentParams = () => {
    const params = getQueryParams();
    return {
      keyword: params.keyword || '',
      pageNo: params.pageNo || '1'
    };
  };

  const updateUrl = (params) => {
    const queryString = buildQueryString(params);
    window.location.href = `/admin/book?action=list${queryString}`;
  };

  if (searchForm) {
    searchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const keywordInput = $('#keyword');
      const params = getCurrentParams();
      params.keyword = keywordInput ? keywordInput.value.trim() : '';
      params.pageNo = '1';
      updateUrl(params);
    });
  }

  handlePagination('#pagination', (page) => {
    const params = getCurrentParams();
    params.pageNo = String(page);
    updateUrl(params);
  });

  if (coverUpload && coverInput && coverPreview) {
    coverUpload.addEventListener('click', () => {
      coverInput.click();
    });

    coverInput.addEventListener('change', async (e) => {
      const file = e.target.files[0];
      if (!file) return;

      if (!file.type.startsWith('image/')) {
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 5MB', 'error');
        return;
      }

      const reader = new FileReader();
      reader.onload = (event) => {
        coverPreview.src = event.target.result;
      };
      reader.readAsDataURL(file);

      try {
        const response = await uploadFile(file, 'bookCover');
        
        if (response.success) {
          if (coverPath) {
            coverPath.value = response.path;
          }
          showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'success');
        } else {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        }
      } catch (e) {
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
      }
    });
  }

  let imageIndex = 0;

  const addImageItem = (path = '', name = '') => {
    if (!imagesContainer) return;

    const item = document.createElement('div');
    item.className = 'multi-image-item';
    item.dataset.index = imageIndex;

    const index = imageIndex;
    item.innerHTML = `
      <img src="${path ? path : ''}" alt="" class="${path ? '' : 'd-none'}">
      <input type="hidden" name="imagePaths" value="${path}">
      <input type="hidden" name="imageNames" value="${name}">
      <button type="button" class="multi-image-remove">&times;</button>
    `;

    const fileInput = document.createElement('input');
    fileInput.type = 'file';
    fileInput.accept = 'image/*';
    fileInput.style.display = 'none';
    
    item.appendChild(fileInput);

    if (!path) {
      const placeholder = document.createElement('div');
      placeholder.className = 'multi-image-add';
      placeholder.innerHTML = '+';
      placeholder.style.position = 'absolute';
      placeholder.style.top = '0';
      placeholder.style.left = '0';
      placeholder.style.width = '100%';
      placeholder.style.height = '100%';
      item.appendChild(placeholder);

      placeholder.addEventListener('click', () => fileInput.click());
    }

    fileInput.addEventListener('change', async (e) => {
      const file = e.target.files[0];
      if (!file) return;

      if (!file.type.startsWith('image/')) {
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 5MB', 'error');
        return;
      }

      const reader = new FileReader();
      reader.onload = (event) => {
        const img = item.querySelector('img');
        img.src = event.target.result;
        img.classList.remove('d-none');
        const ph = item.querySelector('.multi-image-add');
        if (ph) ph.remove();
      };
      reader.readAsDataURL(file);

      try {
        const response = await uploadFile(file, 'bookImages');
        
        if (response.success) {
          const pathInput = item.querySelector('input[name="imagePaths"]');
          const nameInput = item.querySelector('input[name="imageNames"]');
          if (pathInput) pathInput.value = response.path || response.paths?.[0] || '';
          if (nameInput) nameInput.value = file.name;
        } else {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        }
      } catch (e) {
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
      }
    });

    const removeBtn = item.querySelector('.multi-image-remove');
    if (removeBtn) {
      removeBtn.addEventListener('click', () => {
        item.remove();
      });
    }

    imagesContainer.appendChild(item);
    imageIndex++;
  };

  if (addImageBtn && imagesContainer) {
    addImageBtn.addEventListener('click', () => {
      addImageItem();
    });
  }

  if (imagesContainer) {
    const existingImages = imagesContainer.querySelectorAll('.multi-image-item');
    imageIndex = existingImages.length;
    
    existingImages.forEach((item, index) => {
      const removeBtn = item.querySelector('.multi-image-remove');
      if (removeBtn) {
        removeBtn.addEventListener('click', () => {
          item.remove();
        });
      }
    });
  }

  if (bookForm) {
    const titleInput = $('#title');
    const authorInput = $('#author');
    const isbnInput = $('#isbn');
    const categoryInput = $('#categoryId');
    const priceInput = $('#price');
    const stockInput = $('#stock');

    const showError = (input, message) => {
      const formGroup = input.closest('.form-group');
      if (!formGroup) return;
      
      input.classList.add('error');
      input.classList.remove('success');
      
      let errorText = formGroup.querySelector('.form-text');
      if (!errorText) {
        errorText = document.createElement('div');
        errorText.className = 'form-text error';
        formGroup.appendChild(errorText);
      }
      errorText.className = 'form-text error';
      errorText.textContent = message;
    };

    const showSuccess = (input) => {
      const formGroup = input.closest('.form-group');
      if (!formGroup) return;
      
      input.classList.remove('error');
      input.classList.add('success');
      
      const errorText = formGroup.querySelector('.form-text');
      if (errorText) {
        errorText.remove();
      }
    };

    const validateTitle = () => {
      const value = titleInput.value.trim();
      if (Validator.isEmpty(value)) {
        showError(titleInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(titleInput);
      return true;
    };

    const validateAuthor = () => {
      const value = authorInput.value.trim();
      if (Validator.isEmpty(value)) {
        showError(authorInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(authorInput);
      return true;
    };

    const validateCategory = () => {
      const value = categoryInput.value;
      if (!value) {
        showError(categoryInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(categoryInput);
      return true;
    };

    const validatePrice = () => {
      const value = priceInput.value;
      if (Validator.isEmpty(value)) {
        showError(priceInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      if (!Validator.isNumber(value) || parseFloat(value) < 0) {
        showError(priceInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(priceInput);
      return true;
    };

    const validateStock = () => {
      const value = stockInput.value;
      if (Validator.isEmpty(value)) {
        showError(stockInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      if (!Validator.isInt(value) || parseInt(value) < 0) {
        showError(stockInput, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
        return false;
      }
      showSuccess(stockInput);
      return true;
    };

    if (titleInput) {
      titleInput.addEventListener('blur', validateTitle);
      titleInput.addEventListener('input', () => {
        if (titleInput.classList.contains('error')) {
          titleInput.classList.remove('error');
          const formGroup = titleInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    if (authorInput) {
      authorInput.addEventListener('blur', validateAuthor);
      authorInput.addEventListener('input', () => {
        if (authorInput.classList.contains('error')) {
          authorInput.classList.remove('error');
          const formGroup = authorInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    if (categoryInput) {
      categoryInput.addEventListener('change', validateCategory);
    }

    if (priceInput) {
      priceInput.addEventListener('blur', validatePrice);
      priceInput.addEventListener('input', () => {
        if (priceInput.classList.contains('error')) {
          priceInput.classList.remove('error');
          const formGroup = priceInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    if (stockInput) {
      stockInput.addEventListener('blur', validateStock);
      stockInput.addEventListener('input', () => {
        if (stockInput.classList.contains('error')) {
          stockInput.classList.remove('error');
          const formGroup = stockInput.closest('.form-group');
          const errorText = formGroup?.querySelector('.form-text');
          if (errorText) errorText.remove();
        }
      });
    }

    bookForm.addEventListener('submit', (e) => {
      let isValid = true;
      
      if (titleInput && !validateTitle()) isValid = false;
      if (authorInput && !validateAuthor()) isValid = false;
      if (categoryInput && !validateCategory()) isValid = false;
      if (priceInput && !validatePrice()) isValid = false;
      if (stockInput && !validateStock()) isValid = false;

      if (!isValid) {
        e.preventDefault();
        return;
      }

      if (submitBtn) {
        setButtonLoading(submitBtn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');
      }
    });
  }

  const deleteButtons = $$('.delete-btn');
  deleteButtons.forEach(btn => {
    btn.addEventListener('click', async (e) => {
      e.preventDefault();
      const bookId = btn.dataset.id;
      if (!bookId) return;

      const confirmed = await showConfirm(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ？ '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value 。', ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      if (!confirmed) return;

      showLoading();

      try {
        window.location.href = `/admin/book?action=delete&id=${bookId}`;
      } catch (e) {
        hideLoading();
        showToast(' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
      }
    });
  });

  const statusButtons = $$('.status-toggle');
  statusButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const bookId = btn.dataset.id;
      const currentStatus = btn.dataset.status;
      const newStatus = currentStatus === '1' ? '0' : '1';
      
      const action = newStatus === '1' ? ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ' : ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ';
      const confirmed = await showConfirm(` '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ${action} '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ？`, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ');
      if (!confirmed) return;

      setButtonLoading(btn, true, ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ...');

      try {
        const response = await ajax('/admin/book', {
          method: 'POST',
          data: {
            action: 'updateStatus',
            id: bookId,
            status: newStatus
          }
        });

        if (response.success) {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'success');
          setTimeout(() => {
            window.location.reload();
          }, 1000);
        } else {
          showToast(response.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
          setButtonLoading(btn, false);
        }
      } catch (e) {
        showToast(e.message || ' '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value  '\u{0:x4}' -f [int]$args[0].Value ', 'error');
        setButtonLoading(btn, false);
      }
    });
  });

  handleTableSort('#bookTable', (field, order) => {
    const params = getCurrentParams();
    params.sortField = field;
    params.sortOrder = order;
    params.pageNo = '1';
    updateUrl(params);
  });
});
