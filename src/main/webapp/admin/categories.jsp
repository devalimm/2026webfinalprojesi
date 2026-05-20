<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:include page="includes/admin-header.jsp" />

            <h2 class="page-title">Kategori Yönetimi</h2>

            <div class="action-bar">
                <a href="${pageContext.request.contextPath}/admin/categories?action=add" class="btn btn-primary">Yeni
                    Kategori Ekle</a>
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
                            <th>ID</th>
                            <th>Ad</th>
                            <th>Açıklama</th>
                            <th>Durum</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty categories}">
                                <c:forEach var="category" items="${categories}">
                                    <tr>
                                        <td>${category.id}</td>
                                        <td>
                                            <c:out value="${category.name}" />
                                        </td>
                                        <td>
                                            <c:out value="${category.description}" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${category.active}">
                                                    <span class="badge" style="background-color: #27ae60;">Aktif</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge" style="background-color: #e74c3c;">Pasif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${category.id}"
                                                    class="btn btn-sm btn-primary">Düzenle</a>
                                                <form action="${pageContext.request.contextPath}/admin/categories"
                                                    method="post" style="display: inline;"
                                                    onsubmit="return confirm('Bu kategoriyi silmek istediğinize emin misiniz?');">
                                                    <input type="hidden" name="action" value="delete" />
                                                    <input type="hidden" name="id" value="${category.id}" />
                                                    <button type="submit" class="btn btn-sm btn-danger">Sil</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 30px; color: #7f8c8d;">Henüz
                                        kategori bulunmamaktadır.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <jsp:include page="includes/admin-footer.jsp" />