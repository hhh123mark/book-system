﻿﻿﻿﻿﻿document.addEventListener('DOMContentLoaded', () => {
  const searchForm = $('#searchForm');
  const categorySelect = $('#categorySelect');
  const sortFieldInput = $('#sortField');
  const sortOrderInput = $('#sortOrder');
  const keywordInput = $('#keyword');

  const getCurrentParams = () => {
    const params = getQueryParams();
    return {
      keyword: params.keyword || '',
      categoryId: params.categoryId || '',
      sortField: params.sortField || '',
      sortOrder: params.sortOrder || '',
      pageNo: params.pageNo || '1'
    };
  };

  const updateUrl = (params) => {
    const queryString = buildQueryString(params);
    window.location.href = `${window.location.pathname}${queryString}`;
  };

  if (searchForm) {
    searchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const params = getCurrentParams();
      params.keyword = keywordInput ? keywordInput.value.trim() : '';
      params.pageNo = '1';
      updateUrl(params);
    });
  }

  if (categorySelect) {
    categorySelect.addEventListener('change', () => {
      const params = getCurrentParams();
      params.categoryId = categorySelect.value;
      params.pageNo = '1';
      updateUrl(params);
    });
  }

  handleTableSort('#bookTable', (field, order) => {
    const params = getCurrentParams();
    params.sortField = field;
    params.sortOrder = order;
    params.pageNo = '1';
    updateUrl(params);
  });

  handlePagination('#pagination', (page) => {
    const params = getCurrentParams();
    params.pageNo = String(page);
    updateUrl(params);
  });

  const initSortState = () => {
    const params = getCurrentParams();
    if (!params.sortField) return;
    
    const th = document.querySelector(`#bookTable th[data-sort="${params.sortField}"]`);
    if (th) {
      th.classList.add(`sort-${params.sortOrder}`);
    }
  };

  initSortState();

  const borrowButtons = $$('.borrow-btn');
  borrowButtons.forEach(btn => {
    btn.addEventListener('click', async () => {
      const bookId = btn.dataset.bookId;
      if (!bookId) return;

      const confirmed = await showConfirm('\u786e\u8ba4\u501f\u9605\u8fd9\u672c\u56fe\u4e66\u5417\uff1f', '\u501f\u9605\u786e\u8ba4');
      if (!confirmed) return;

      setButtonLoading(btn, true, '\u501f\u9605\u4e2d...');

      try {
        const response = await ajax(getContextPath() + '/borrow', {
          method: 'POST',
          data: {
            action: 'borrow',
            bookId: bookId,
            days: 30
          }
        });

        if (response.success) {
          showToast(response.message || '\u501f\u9605\u6210\u529f', 'success');
          setTimeout(() => {
            window.location.reload();
          }, 1000);
        } else {
          showToast(response.message || '\u501f\u9605\u5931\u8d25', 'error');
          setButtonLoading(btn, false);
        }
      } catch (e) {
        showToast(e.message || '\u7f51\u7edc\u9519\u8bef\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5', 'error');
        setButtonLoading(btn, false);
      }
    });
  });

  const viewToggleButtons = $$('.view-toggle button');
  const bookContainer = $('#bookContainer');
  
  if (viewToggleButtons.length && bookContainer) {
    viewToggleButtons.forEach(btn => {
      btn.addEventListener('click', () => {
        const view = btn.dataset.view;
        
        viewToggleButtons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        
        if (view === 'grid') {
          bookContainer.classList.add('book-grid');
          bookContainer.classList.remove('table-container');
        } else {
          bookContainer.classList.remove('book-grid');
          bookContainer.classList.add('table-container');
        }
      });
    });
  }
});
