<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:include page="includes/admin-header.jsp" />

            <h2 class="page-title">Ürün Yönetimi</h2>

            <div class="action-bar">
                <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-primary">Yeni Ürün
                    Ekle</a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <div class="data-table">
                <table>
                    <thead>
                        <tr>
                            <th>Ürün ID</th>
                            <th>Ürün Adı</th>
                            <th>Kategori</th>
                            <th>Fiyat</th>
                            <th>Stok</th>
                            <th>Durum</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty products}">
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td>${product.id}</td>
                                        <td>
                                            <c:out value="${product.name}" />
                                        </td>
                                        <td>
                                            <c:out value="${product.categoryName}" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${product.price}" type="currency"
                                                currencySymbol="₺" maxFractionDigits="2" />
                                        </td>
                                        <td>${product.stock}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.active}">
                                                    <span class="badge" style="background-color: #27ae60;">Aktif</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge" style="background-color: #e74c3c;">Pasif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${product.id}"
                                                    class="btn btn-sm btn-primary">Düzenle</a>
                                                <form action="${pageContext.request.contextPath}/admin/products"
                                                    method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="toggle" />
                                                    <input type="hidden" name="id" value="${product.id}" />
                                                    <input type="hidden" name="active"
                                                        value="${product.active ? 'false' : 'true'}" />
                                                    <button type="submit"
                                                        class="btn btn-sm ${product.active ? 'btn-warning' : 'btn-success'}">
                                                        ${product.active ? 'Pasif Yap' : 'Aktif Yap'}
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/products"
                                                    method="post" style="display: inline;"
                                                    onsubmit="return confirm('Bu ürünü silmek istediğinize emin misiniz?');">
                                                    <input type="hidden" name="action" value="delete" />
                                                    <input type="hidden" name="id" value="${product.id}" />
                                                    <button type="submit" class="btn btn-sm btn-danger">Sil</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 30px; color: #7f8c8d;">Henüz
                                        ürün bulunmamaktadır.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <jsp:include page="includes/admin-footer.jsp" />