<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Sổ địa chỉ - Organic Harvest</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
            <link rel="stylesheet" href="<c:url value='/assets/css/base.css'/>" />
            <link rel="stylesheet" href="<c:url value='/assets/css/main.css'/>" />
            <link rel="stylesheet" href="<c:url value='/assets/css/profile.css'/>" />
            <link rel="stylesheet" href="<c:url value='/assets/css/addresses.css'/>" />
            <style>
                .alert {
                    padding: 10px 15px;
                    margin-bottom: 15px;
                    border-radius: 4px;
                }

                .alert-success {
                    background-color: #d4edda;
                    color: #155724;
                    border: 1px solid #c3e6cb;
                }

                .alert-danger {
                    background-color: #f8d7da;
                    color: #721c24;
                    border: 1px solid #f5c6cb;
                }

                .empty-addresses {
                    text-align: center;
                    padding: 40px;
                    color: #888;
                }

                .empty-addresses i {
                    font-size: 48px;
                    margin-bottom: 15px;
                    color: #ccc;
                }
            </style>
            <c:if test="${addr.defaultAddress}">
                <button class="btn btn-outline btn-sm disabled" disabled>Thiết lập mặc
                    định</button>
            </c:if>
            </div>
            </div>
            </c:forEach>
            </div>
            </main>
            </div>
            </div>
            </section>

            <div class="modal" id="addressModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 id="modalTitle">Địa chỉ mới</h3>
                        <span class="close-modal">&times;</span>
                    </div>
                    <div class="modal-body">
                        <form class="address-form" action="<c:url value='/addresses'/>" method="post">
                            <input type="hidden" name="action" id="formAction" value="add" />
                            <input type="hidden" name="addressId" id="addressId" value="" />

                            <div class="form-row">
                                <input type="text" name="receiverName" id="receiverName" class="form-input"
                                    placeholder="Họ và tên" required />
                                <input type="tel" name="phoneNumber" id="phoneNumber" class="form-input"
                                    placeholder="Số điện thoại" pattern="0[3578][0-9]{8}" inputmode="numeric"
                                    maxlength="10" title="Số điện thoại phải có 10 chữ số. Ví dụ: 0912345678"
                                    required />
                            </div>
                            <div class="form-group">
                                <div style="display: flex; gap: 8px;">
                                    <select name="province" id="provinceSelect" class="form-input" style="flex:1">
                                        <option value="">Chọn Tỉnh/Thành phố</option>
                                    </select>
                                    <select name="district" id="districtSelect" class="form-input" style="flex:1">
                                        <option value="">Chọn Quận/Huyện</option>
                                    </select>
                                    <select name="ward" id="wardSelect" class="form-input" style="flex:1">
                                        <option value="">Chọn Phường/Xã</option>
                                    </select>
                                </div>
                                <input type="hidden" name="city" id="city" value="" />
                            </div>
                            <div class="form-group">
                                <textarea name="address" id="address" class="form-input"
                                    placeholder="Địa chỉ cụ thể (Số nhà, tên đường...)" rows="2" required></textarea>
                            </div>

                            <c:if test="${not empty addresses}">
                                <div class="form-group">
                                    <label class="checkbox-label">
                                        <input type="checkbox" name="isDefault" id="isDefault" /> Đặt làm địa chỉ mặc
                                        định
                                    </label>
                                </div>
                            </c:if>
                            <c:if test="${empty addresses}">
                                <input type="hidden" name="isDefault" value="1" />
                                <p style="color: #666; font-size: 14px; margin-bottom: 15px;">
                                    <i class="fa-solid fa-info-circle"></i> Địa chỉ đầu tiên sẽ tự động là mặc định
                                </p>
                            </c:if>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline close-modal-btn">Trở lại</button>
                                <button type="submit" class="btn btn-primary">Hoàn thành</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <jsp:include page="footer.jsp"></jsp:include>

            <script>
                const modal = document.getElementById("addressModal");
                const btnAdd = document.getElementById("btnAddAddress");
                const spanClose = document.getElementsByClassName("close-modal")[0];
                const btnClose = document.getElementsByClassName("close-modal-btn")[0];
                const phoneInput = document.getElementById("phoneNumber");
                const provinceSel = document.getElementById('provinceSelect');
                const districtSel = document.getElementById('districtSelect');
                const wardSel = document.getElementById('wardSelect');
                const cityHidden = document.getElementById('city');

                phoneInput.addEventListener('input', function (e) {
                    this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);
                });

                let currentProvinceData = null;

                function clearSelect(sel, placeholder) {
                    sel.innerHTML = '';
                    const opt = document.createElement('option');
                    opt.value = '';
                    opt.textContent = placeholder;
                    sel.appendChild(opt);
                }

                async function loadProvinces() {
                    if (!provinceSel) return;
                    clearSelect(provinceSel, 'Chọn Tỉnh/Thành phố');
                    try {
                        const res = await fetch('https://provinces.open-api.vn/api/?depth=1');
                        const data = await res.json();
                        data.forEach(p => {
                            const o = document.createElement('option');
                            o.value = p.code;
                            o.textContent = p.name;
                            provinceSel.appendChild(o);
                        });
                        const cityVal = cityHidden?.value || '';
                        if (cityVal) tryPrefillFromCity(cityVal);
                    } catch (e) {
                        console.error(e);
                    }
                }

                async function onProvinceChange() {
                    clearSelect(districtSel, 'Chọn Quận/Huyện');
                    clearSelect(wardSel, 'Chọn Phường/Xã');
                    const code = provinceSel.value;
                    currentProvinceData = null;
                    if (!code) return;
                    try {
                        const res = await fetch('https://provinces.open-api.vn/api/p/' + code + '?depth=2');
                        const data = await res.json();
                        currentProvinceData = data;
                        data.districts.forEach(d => {
                            const o = document.createElement('option');
                            o.value = d.code;
                            o.textContent = d.name;
                            districtSel.appendChild(o);
                        });
                        const cityVal = cityHidden?.value || '';
                        if (cityVal) {
                            const parts = cityVal.split(',').map(s => s.trim());
                            if (parts[1]) {
                                const match = Array.from(districtSel.options).find(o => o.text === parts[1]);
                                if (match) {
                                    districtSel.value = match.value;
                                    onDistrictChange();
                                }
                            }
                        }
                    } catch (e) {
                        console.error(e);
                    }
                }

                function onDistrictChange() {
                    clearSelect(wardSel, 'Chọn Phường/Xã');
                    const dCode = districtSel.value;
                    if (!dCode || !currentProvinceData) return;
                    const district = currentProvinceData.districts.find(d => String(d.code) === String(dCode));
                    if (!district) return;
                    (district.wards || []).forEach(w => {
                        const o = document.createElement('option');
                        o.value = w.code;
                        o.textContent = w.name;
                        wardSel.appendChild(o);
                    });
                    const cityVal = cityHidden?.value || '';
                    if (cityVal) {
                        const parts = cityVal.split(',').map(s => s.trim());
                        if (parts[2]) {
                            const match = Array.from(wardSel.options).find(o => o.text === parts[2]);
                            if (match) wardSel.value = match.value;
                        }
                    }
                }

                function tryPrefillFromCity(cityStr) {
                    const parts = cityStr.split(',').map(s => s.trim());
                    if (!parts.length) return;
                    const provName = parts[0];
                    const match = Array.from(provinceSel.options).find(o => o.text === provName);
                    if (match) {
                        provinceSel.value = match.value;
                        onProvinceChange();
                    }
                }

                provinceSel?.addEventListener('change', onProvinceChange);
                districtSel?.addEventListener('change', onDistrictChange);

                loadProvinces();

                document.querySelector('.address-form').addEventListener('submit', function (e) {
                    if (provinceSel) {
                        if (provinceSel.value) {
                            const provinceText = provinceSel.options[provinceSel.selectedIndex].text || '';
                            const districtText = districtSel.options[districtSel.selectedIndex]?.text || '';
                            const wardText = wardSel.options[wardSel.selectedIndex]?.text || '';
                            cityHidden.value = [provinceText, districtText, wardText].filter(Boolean).join(', ');
                        } else if (!cityHidden.value.trim()) {
                            e.preventDefault();
                            alert('Vui lòng chọn Tỉnh/Thành phố hoặc điền địa chỉ hợp lệ.');
                            return false;
                        }
                    }

                    const phoneValue = phoneInput.value.trim();
                    const phoneRegex = /^0[3578][0-9]{8}$/;

                    if (phoneValue && !phoneRegex.test(phoneValue)) {
                        e.preventDefault();
                        alert('Số điện thoại không hợp lệ.\n\nYêu cầu: 10 chữ số, bắt đầu từ 03, 05, 07, 08 hoặc 09.\nVí dụ: 0912345678');
                        phoneInput.focus();
                        return false;
                    }
                });

                function resetForm() {
                    document.getElementById("modalTitle").textContent = "Địa chỉ mới";
                    document.getElementById("formAction").value = "add";
                    document.getElementById("addressId").value = "";
                    document.getElementById("receiverName").value = "";
                    document.getElementById("phoneNumber").value = "";
                    if (provinceSel) provinceSel.value = "";
                    if (districtSel) districtSel.value = "";
                    if (wardSel) wardSel.value = "";
                    if (cityHidden) cityHidden.value = "";
                    document.getElementById("address").value = "";

                    const isDefaultCheckbox = document.getElementById("isDefault");
                    if (isDefaultCheckbox) isDefaultCheckbox.checked = false;
                }

                btnAdd.onclick = function () {
                    resetForm();
                    modal.style.display = "flex";
                };

                const closeModal = () => { modal.style.display = "none"; };
                spanClose.onclick = closeModal;
                btnClose.onclick = closeModal;

                window.onclick = function (event) {
                    if (event.target == modal) closeModal();
                };

                document.querySelectorAll('.btn-edit').forEach(btn => {
                    btn.onclick = function () {
                        document.getElementById("modalTitle").textContent = "Cập nhật địa chỉ";
                        document.getElementById("formAction").value = "update";
                        document.getElementById("addressId").value = this.dataset.id;
                        document.getElementById("receiverName").value = this.dataset.name;
                        document.getElementById("phoneNumber").value = this.dataset.phone;
                        if (provinceSel) { provinceSel.value = ""; districtSel.value = ""; wardSel.value = ""; }
                        if (cityHidden) cityHidden.value = this.dataset.city;
                        document.getElementById("address").value = this.dataset.address;

                        const isDefaultCheckbox = document.getElementById("isDefault");
                        if (isDefaultCheckbox) isDefaultCheckbox.checked = this.dataset.default === "true";

                        modal.style.display = "flex";
                    };
                });
            </script>
            </body>

        </html>