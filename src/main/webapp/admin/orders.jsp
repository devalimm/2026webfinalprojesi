<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:include page="includes/admin-header.jsp" />

            <h2 class="page-title">Sipariş Yönetimi</h2>

            <div class="data-table">
                <table>
                    <thead>
                        <tr>
                            <th>Sipariş ID</th>
                            <th>Müşteri</th>
                            <th>Tarih</th>
                            <th>Tutar</th>
                            <th>Durum</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty orders}">
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>${order.id}</td>
                                        <td>
                                            <c:out value="${order.userName}" />
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd.MM.yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                currencySymbol="₺" maxFractionDigits="2" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'Beklemede'}"><span
                                                        class="badge badge-beklemede">Beklemede</span></c:when>
                                                <c:when test="${order.status == 'Hazırlanıyor'}"><span
                                                        class="badge badge-hazirlaniyor">Hazırlanıyor</span></c:when>
                                                <c:when test="${order.status == 'Kargoya Verildi'}"><span
                                                        class="badge badge-kargoya-verildi">Kargoya Verildi</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Tamamlandı'}"><span
                                                        class="badge badge-tamamlandi">Tamamlandı</span></c:when>
                                                <c:when test="${order.status == 'İptal Edildi'}"><span
                                                        class="badge badge-iptal-edildi">İptal Edildi</span></c:when>
                                                <c:otherwise><span class="badge">
                                                        <c:out value="${order.status}" />
                                                    </span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px; flex-wrap: wrap; align-items: center;">
                                                <a href="${pageContext.request.contextPath}/admin/orders?id=${order.id}"
                                                    class="btn btn-sm btn-primary">Detay</a>
                                                <form action="${pageContext.request.contextPath}/admin/orders"
                                                    method="post" class="status-update-form">
                                                    <input type="hidden" name="action" value="updateStatus" />
                                                    <input type="hidden" name="id" value="${order.id}" />
                                                    <select name="status">
                                                        <option value="Beklemede" ${order.status=='Beklemede'
                                                            ? 'selected' : '' }>Beklemede</option>
                                                        <option value="Hazırlanıyor" ${order.status=='Hazırlanıyor'
                                                            ? 'selected' : '' }>Hazırlanıyor</option>
                                                        <option value="Kargoya Verildi"
                                                            ${order.status=='Kargoya Verildi' ? 'selected' : '' }>
                                                            Kargoya Verildi</option>
                                                        <option value="Tamamlandı" ${order.status=='Tamamlandı'
                                                            ? 'selected' : '' }>Tamamlandı</option>
                                                        <option value="İptal Edildi" ${order.status=='İptal Edildi'
                                                            ? 'selected' : '' }>İptal Edildi</option>
                                                    </select>
                                                    <button type="submit"
                                                        class="btn btn-sm btn-success">Güncelle</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 30px; color: #7f8c8d;">Henüz
                                        sipariş bulunmamaktadır.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <jsp:include page="includes/admin-footer.jsp" />