<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:include page="includes/admin-header.jsp" />

            <h2 class="page-title">
                <c:out value="${not empty category ? 'Kategori Düzenle' : 'Yeni Kategori Ekle'}" />
            </h2>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <div class="form-container" style="max-width: 600px; margin: 0;">
                <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                    <c:choose>
                        <c:when test="${not empty category}">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" value="${category.id}" />
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="add" />
                        </c:otherwise>
                    </c:choose>

                    <div class="form-group">
                        <label for="name">Kategori Adı</label>
                        <input type="text" id="name" name="name" value="<c:out value=" ${not empty category ?
                            category.name : '' }" />" required />
                    </div>

                    <div class="form-group">
                        <label for="description">Açıklama</label>
                        <textarea id="description" name="description"
                            rows="3"><c:out value="${not empty category ? category.description : ''}" /></textarea>
                    </div>

                    <div class="form-group">
                        <label>
                            <input type="checkbox" name="is_active" ${not empty category && category.active ? 'checked'
                                : '' } />
                            Aktif
                        </label>
                    </div>

                    <div class="form-actions" style="display: flex; gap: 10px; margin-top: 20px;">
                        <button type="submit" class="btn btn-primary">Kaydet</button>
                        <a href="${pageContext.request.contextPath}/admin/categories"
                            class="btn btn-secondary">İptal</a>
                    </div>
                </form>
            </div>

            <jsp:include page="includes/admin-footer.jsp" />