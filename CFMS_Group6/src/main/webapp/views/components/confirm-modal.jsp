<%--
    Reusable confirmation modal component for CFMS.
    Usage from JSP:
      CFMS_CONFIRM({
          title: 'Xác nhận',
          message: 'Nội dung...',
          danger: true/false,
          requireReason: true/false,
          reasonLabel: 'Lý do',
          reasonPlaceholder: 'Nhập lý do...',
          extraHtml: '<div>HTML bổ sung (tùy chọn)</div>',
          onConfirm: function (reasonText, quantityValue) { ... }
      });
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/confirm.css">

<div class="modal fade cfms-confirm-modal" id="cfmsConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title" id="cfmsConfirmTitle">Xác nhận thao tác</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="cfmsConfirmMessage"></p>
                <div id="cfmsConfirmReasonGroup" class="mb-0 d-none">
                    <label for="cfmsConfirmReason" class="form-label small" id="cfmsConfirmReasonLabel">
                        Lý do
                    </label>
                    <textarea class="form-control" id="cfmsConfirmReason" rows="3"></textarea>
                </div>
                <div id="cfmsConfirmExtraGroup" class="mt-2 d-none">
                    <div id="cfmsConfirmExtraContent" class="small"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">
                    Hủy
                </button>
                <button type="button" class="btn btn-primary btn-sm" id="cfmsConfirmOkBtn">
                    Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    window.CFMS_CONFIRM = (function () {
        var modalEl = document.getElementById('cfmsConfirmModal');
        if (!modalEl) {
            return function () {
            };
        }

        var modal = null;
        var titleEl = document.getElementById('cfmsConfirmTitle');
        var messageEl = document.getElementById('cfmsConfirmMessage');
        var okBtn = document.getElementById('cfmsConfirmOkBtn');
        var reasonGroup = document.getElementById('cfmsConfirmReasonGroup');
        var reasonInput = document.getElementById('cfmsConfirmReason');
        var reasonLabel = document.getElementById('cfmsConfirmReasonLabel');
        var extraGroup = document.getElementById('cfmsConfirmExtraGroup');
        var extraContent = document.getElementById('cfmsConfirmExtraContent');

        function ensureModalInstance() {
            if (!modal && window.bootstrap && window.bootstrap.Modal) {
                modal = new bootstrap.Modal(modalEl);
            }
        }

        return function (options) {
            options = options || {};
            ensureModalInstance();
            if (!modal) {
                // Fallback: if Bootstrap is not ready, just execute immediately
                if (typeof options.onConfirm === 'function') {
                    options.onConfirm('');
                }
                return;
            }

            titleEl.textContent = options.title || 'Xác nhận thao tác';
            messageEl.textContent = options.message || '';

            // Configure reason input
            reasonInput.value = '';
            if (options.requireReason) {
                reasonGroup.classList.remove('d-none');
                reasonLabel.textContent = options.reasonLabel || 'Lý do';
                reasonInput.placeholder = options.reasonPlaceholder || 'Nhập lý do...';
            } else {
                reasonGroup.classList.add('d-none');
            }

            // Configure extra content (HTML)
            if (options.extraHtml) {
                extraGroup.classList.remove('d-none');
                extraContent.innerHTML = options.extraHtml;
            } else {
                extraGroup.classList.add('d-none');
                extraContent.innerHTML = '';
            }

            // Button style
            if (options.danger) {
                okBtn.classList.remove('btn-primary');
                okBtn.classList.add('btn-danger');
            } else {
                okBtn.classList.remove('btn-danger');
                okBtn.classList.add('btn-primary');
            }

            // Clear previous handler
            var newHandler = function () {
                var reasonText = reasonInput.value ? reasonInput.value.trim() : '';
                var quantityValue = null;

                if (options.requireReason && !reasonText) {
                    reasonInput.classList.add('is-invalid');
                    return;
                }
                reasonInput.classList.remove('is-invalid');

                if (typeof options.onConfirm === 'function') {
                    // Truyền thêm quantityValue (dự phòng cho tương lai),
                    // các hàm hiện tại chỉ cần tham số đầu tiên sẽ bỏ qua tham số thứ 2.
                    options.onConfirm(reasonText, quantityValue);
                }
                okBtn.removeEventListener('click', newHandler);
                modal.hide();
            };

            okBtn.addEventListener('click', newHandler);
            modal.show();
        };
    })();
</script>

