const $ = (selector) => document.querySelector(selector);
const $$ = (selector) => document.querySelectorAll(selector);

const getContextPath = () => {
  const metaTag = document.querySelector('meta[name="context-path"]');
  if (metaTag) {
    return metaTag.content;
  }
  return '';
};

const getCsrfToken = () => {
  const metaTag = document.querySelector('meta[name="csrf-token"]');
  if (metaTag) {
    return metaTag.content;
  }
  return window.csrfToken || '';
};

const ajax = (url, options = {}) => {
  const {
    method = 'GET',
    data = null,
    headers = {},
    isJson = true,
    timeout = 30000
  } = options;

  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.timeout = timeout;
    xhr.open(method, url, true);

    if (isJson && !(data instanceof FormData)) {
      xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    }

    if (method.toUpperCase() === 'POST') {
      const csrfToken = getCsrfToken();
      if (csrfToken) {
        xhr.setRequestHeader('X-CSRF-Token', csrfToken);
      }
    }

    Object.keys(headers).forEach(key => {
      xhr.setRequestHeader(key, headers[key]);
    });

    xhr.onload = () => {
      if (xhr.status >= 200 && xhr.status < 300) {
        try {
          const response = JSON.parse(xhr.responseText);
          resolve(response);
        } catch (e) {
          resolve(xhr.responseText);
        }
      } else {
        reject({
          status: xhr.status,
          message: xhr.statusText || '\u7f51\u7edc\u9519\u8bef'
        });
      }
    };

    xhr.onerror = () => {
      reject({
        status: 0,
        message: '\u7f51\u7edc\u9519\u8bef\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5'
      });
    };

    xhr.ontimeout = () => {
      reject({
        status: 0,
        message: '\u8bf7\u6c42\u8d85\u65f6\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5'
      });
    };

    let sendData = data;
    if (data && !(data instanceof FormData) && isJson && method.toUpperCase() === 'POST') {
      if (typeof data === 'object') {
        const params = new URLSearchParams();
        Object.keys(data).forEach(key => {
          params.append(key, data[key]);
        });
        const csrfToken = getCsrfToken();
        if (csrfToken) {
          params.append('csrfToken', csrfToken);
        }
        sendData = params.toString();
      }
    }

    xhr.send(sendData);
  });
};

const showToast = (message, type = 'info', duration = 3000) => {
  let container = $('.toast-container');
  if (!container) {
    container = document.createElement('div');
    container.className = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  
  const icons = {
    success: '✓',
    error: '✕',
    warning: '!',
    info: 'i'
  };
  
  toast.innerHTML = `<span>${icons[type] || icons.info}</span><span>${message}</span>`;
  container.appendChild(toast);

  setTimeout(() => {
    toast.classList.add('hiding');
    setTimeout(() => {
      if (toast.parentNode) {
        toast.parentNode.removeChild(toast);
      }
    }, 300);
  }, duration);
};

const Validator = {
  isEmpty(value) {
    return value === null || value === undefined || String(value).trim() === '';
  },

  isEmail(value) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(String(value).trim());
  },

  isPhone(value) {
    const phoneRegex = /^1[3-9]\d{9}$/;
    return phoneRegex.test(String(value).trim());
  },

  minLength(value, min) {
    return String(value).length >= min;
  },

  maxLength(value, max) {
    return String(value).length <= max;
  },

  isLength(value, min, max) {
    const len = String(value).length;
    return len >= min && len <= max;
  },

  isNumber(value) {
    return !isNaN(parseFloat(value)) && isFinite(value);
  },

  isInt(value) {
    return Number.isInteger(Number(value));
  },

  match(value, pattern) {
    return pattern.test(String(value));
  },

  equals(value1, value2) {
    return value1 === value2;
  },

  getPasswordStrength(password) {
    let strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 10) strength++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
    if (/\d/.test(password)) strength++;
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;

    if (strength <= 2) return { level: 'weak', text: '\u5f31' };
    if (strength <= 3) return { level: 'medium', text: '\u4e2d' };
    return { level: 'strong', text: '\u5f3a' };
  }
};

const showConfirm = (message, title = '\u63d0\u793a') => {
  return new Promise((resolve) => {
    const overlay = document.createElement('div');
    overlay.className = 'modal-overlay';
    
    overlay.innerHTML = `
      <div class="modal">
        <div class="modal-header">
          <h3 class="modal-title">${title}</h3>
          <button class="modal-close">&times;</button>
        </div>
        <div class="modal-body">
          <p>${message}</p>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary cancel-btn">\u53d6\u6d88</button>
          <button class="btn btn-primary confirm-btn">\u786e\u5b9a</button>
        </div>
      </div>
    `;
    
    document.body.appendChild(overlay);
    
    requestAnimationFrame(() => {
      overlay.classList.add('show');
    });
    
    const close = (result) => {
      overlay.classList.remove('show');
      setTimeout(() => {
        if (overlay.parentNode) {
          overlay.parentNode.removeChild(overlay);
        }
        resolve(result);
      }, 200);
    };
    
    overlay.querySelector('.modal-close').addEventListener('click', () => close(false));
    overlay.querySelector('.cancel-btn').addEventListener('click', () => close(false));
    overlay.querySelector('.confirm-btn').addEventListener('click', () => close(true));
    
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) {
        close(false);
      }
    });
  });
};

const uploadFile = (file, type = 'avatar') => {
  return new Promise((resolve, reject) => {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('type', type);
    
    const csrfToken = getCsrfToken();
    if (csrfToken) {
      formData.append('csrfToken', csrfToken);
    }
    
    const xhr = new XMLHttpRequest();
    xhr.open('POST', getContextPath() + '/upload', true);
    
    xhr.onload = () => {
      if (xhr.status >= 200 && xhr.status < 300) {
        try {
          const response = JSON.parse(xhr.responseText);
          if (response.success) {
            resolve(response);
          } else {
            reject(new Error(response.message || '\u4e0a\u4f20\u5931\u8d25'));
          }
        } catch (e) {
          reject(new Error('\u670d\u52a1\u5668\u54cd\u5e94\u683c\u5f0f\u9519\u8bef'));
        }
      } else {
        reject(new Error('\u7cfb\u7edf\u9519\u8bef\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5'));
      }
    };
    
    xhr.onerror = () => {
      reject(new Error('\u7f51\u7edc\u9519\u8bef\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5'));
    };
    
    xhr.send(formData);
  });
};

const handleTableSort = (tableSelector, onSort) => {
  const table = document.querySelector(tableSelector);
  if (!table) return;
  
  const headers = table.querySelectorAll('th[data-sort]');
  
  headers.forEach(th => {
    th.addEventListener('click', () => {
      const sortField = th.dataset.sort;
      const currentOrder = th.classList.contains('sort-asc') ? 'asc' : 
                           th.classList.contains('sort-desc') ? 'desc' : '';
      const newOrder = currentOrder === 'asc' ? 'desc' : 'asc';
      
      headers.forEach(h => {
        h.classList.remove('sort-asc', 'sort-desc');
      });
      
      th.classList.add(`sort-${newOrder}`);
      
      if (typeof onSort === 'function') {
        onSort(sortField, newOrder);
      }
    });
  });
};

const handlePagination = (containerSelector, onPageChange) => {
  const container = document.querySelector(containerSelector);
  if (!container) return;
  
  container.addEventListener('click', (e) => {
    const link = e.target.closest('a');
    if (!link) return;
    
    e.preventDefault();
    
    const page = link.dataset.page;
    if (page && typeof onPageChange === 'function') {
      onPageChange(parseInt(page, 10));
    }
  });
};

const showLoading = (target = null) => {
  if (target) {
    const el = typeof target === 'string' ? document.querySelector(target) : target;
    if (el) {
      el.dataset.loading = 'true';
      const spinner = document.createElement('div');
      spinner.className = 'loading-spinner';
      spinner.style.position = 'absolute';
      spinner.style.top = '50%';
      spinner.style.left = '50%';
      spinner.style.marginTop = '-12px';
      spinner.style.marginLeft = '-12px';
      el.style.position = el.style.position || 'relative';
      el.appendChild(spinner);
    }
  } else {
    if ($('.loading-overlay')) return;
    const overlay = document.createElement('div');
    overlay.className = 'loading-overlay';
    overlay.innerHTML = '<div class="loading-spinner lg"></div>';
    document.body.appendChild(overlay);
  }
};

const hideLoading = (target = null) => {
  if (target) {
    const el = typeof target === 'string' ? document.querySelector(target) : target;
    if (el) {
      delete el.dataset.loading;
      const spinner = el.querySelector('.loading-spinner');
      if (spinner) {
        spinner.remove();
      }
    }
  } else {
    const overlay = $('.loading-overlay');
    if (overlay) {
      overlay.remove();
    }
  }
};

const setButtonLoading = (btn, loading = true, loadingText = '\u5904\u7406\u4e2d...') => {
  if (!btn) return;
  
  if (loading) {
    btn.dataset.originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = `<span class="loading-spinner sm white"></span> ${loadingText}`;
  } else {
    btn.disabled = false;
    btn.innerHTML = btn.dataset.originalText || btn.innerHTML;
  }
};

const getQueryParams = () => {
  const params = {};
  const search = window.location.search.substring(1);
  if (search) {
    search.split('&').forEach(pair => {
      const [key, value] = pair.split('=');
      params[decodeURIComponent(key)] = decodeURIComponent(value || '');
    });
  }
  return params;
};

const buildQueryString = (params) => {
  const parts = [];
  Object.keys(params).forEach(key => {
    if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
      parts.push(`${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`);
    }
  });
  return parts.length ? `?${parts.join('&')}` : '';
};

const formatDate = (date, format = 'YYYY-MM-DD HH:mm:ss') => {
  if (!date) return '';
  const d = new Date(date);
  if (isNaN(d.getTime())) return '';
  
  const pad = (n) => String(n).padStart(2, '0');
  
  return format
    .replace('YYYY', d.getFullYear())
    .replace('MM', pad(d.getMonth() + 1))
    .replace('DD', pad(d.getDate()))
    .replace('HH', pad(d.getHours()))
    .replace('mm', pad(d.getMinutes()))
    .replace('ss', pad(d.getSeconds()));
};

const Modal = {
  create(options = {}) {
    const {
      title = '\u63d0\u793a',
      content = '',
      footer = true,
      confirmText = '\u786e\u5b9a',
      cancelText = '\u53d6\u6d88',
      onConfirm = null,
      onCancel = null,
      width = '500px'
    } = options;

    const overlay = document.createElement('div');
    overlay.className = 'modal-overlay';
    
    overlay.innerHTML = `
      <div class="modal" style="max-width: ${width}">
        <div class="modal-header">
          <h3 class="modal-title">${title}</h3>
          <button class="modal-close">&times;</button>
        </div>
        <div class="modal-body">${content}</div>
        ${footer ? `
        <div class="modal-footer">
          <button class="btn btn-secondary modal-cancel">${cancelText}</button>
          <button class="btn btn-primary modal-confirm">${confirmText}</button>
        </div>
        ` : ''}
      </div>
    `;
    
    document.body.appendChild(overlay);
    
    const modal = {
      element: overlay,
      
      show() {
        requestAnimationFrame(() => {
          overlay.classList.add('show');
        });
        return this;
      },
      
      hide() {
        overlay.classList.remove('show');
        setTimeout(() => {
          if (overlay.parentNode) {
            overlay.parentNode.removeChild(overlay);
          }
        }, 200);
        return this;
      },
      
      setContent(html) {
        overlay.querySelector('.modal-body').innerHTML = html;
        return this;
      },
      
      setTitle(title) {
        overlay.querySelector('.modal-title').textContent = title;
        return this;
      }
    };
    
    overlay.querySelector('.modal-close').addEventListener('click', () => {
      if (onCancel) onCancel();
      modal.hide();
    });
    
    if (footer) {
      overlay.querySelector('.modal-cancel').addEventListener('click', () => {
        if (onCancel) onCancel();
        modal.hide();
      });
      
      overlay.querySelector('.modal-confirm').addEventListener('click', () => {
        if (onConfirm) {
          const result = onConfirm();
          if (result !== false) {
            modal.hide();
          }
        } else {
          modal.hide();
        }
      });
    }
    
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) {
        if (onCancel) onCancel();
        modal.hide();
      }
    });
    
    return modal;
  }
};

const debounce = (fn, delay = 300) => {
  let timer = null;
  return function(...args) {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => {
      fn.apply(this, args);
      timer = null;
    }, delay);
  };
};

const throttle = (fn, delay = 300) => {
  let last = 0;
  return function(...args) {
    const now = Date.now();
    if (now - last >= delay) {
      last = now;
      fn.apply(this, args);
    }
  };
};

window.ajax = ajax;
window.showToast = showToast;
window.Validator = Validator;
window.showConfirm = showConfirm;
window.uploadFile = uploadFile;
window.handleTableSort = handleTableSort;
window.handlePagination = handlePagination;
window.showLoading = showLoading;
window.hideLoading = hideLoading;
window.setButtonLoading = setButtonLoading;
window.getQueryParams = getQueryParams;
window.buildQueryString = buildQueryString;
window.formatDate = formatDate;
window.Modal = Modal;
window.debounce = debounce;
window.throttle = throttle;
window.$ = $;
window.$$ = $$;
window.getCsrfToken = getCsrfToken;
