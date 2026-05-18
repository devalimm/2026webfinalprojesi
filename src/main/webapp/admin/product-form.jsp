<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="includes/admin-header.jsp" />

<h2 class="page-title">
    <c:out value="${not empty product ? 'Ürün Düzenle' : 'Yeni Ürün Ekle'}" />
</h2>

<c:if test="${not empty error}">
    <div class="alert alert-error"><c:out value="${error}" /></div>
</c:if>

<div class="form-container" style="max-width: 600px; margin: 0;">
    <form action="${pageContext.request.contextPath}/admin/products" method="post">
        <c:choose>
            <c:when test="${not empty product}">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" value="${product.id}" />
            </c:when>
            <c:otherwise>
                <input type="hidden" name="action" value="add" />
            </c:otherwise>
        </c:choose>

        <div class="form-group">
            <label for="categoryId">Kategori</label>
            <select id="categoryId" name="category_id" required>
                <option value="">-- Kategori Seçin --</option>
                <c:forEach var="category" items="${categories}">
                    <option value="${category.id}" ${not empty product && product.categoryId == category.id ? 'selected' : ''}>
                        <c:out value="${category.name}" />
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="name">Ürün Adı</label>
            <input type="text" id="name" name="name" value="<c:out value="${not empty product ? product.name : ''}" />" required />
        </div>

        <div class="form-group">
            <label for="description">Açıklama</label>
            <textarea id="description" name="description" rows="4"><c:out value="${not empty product ? product.description : ''}" /></textarea>
        </div>

        <div class="form-group">
            <label for="price">Fiyat</label>
            <input type="number" id="price" name="price" step="0.01" value="${not empty product ? product.price : ''}" required />
        </div>

        <div class="form-group">
            <label for="stock">Stok Miktarı</label>
            <input type="number" id="stock" name="stock" value="${not empty product ? product.stock : '0'}" required />
        </div>

        <div class="form-group">
            <label for="imageUrl">Görsel URL</label>
            <input type="text" id="imageUrl" name="imageUrl" value="<c:out value="${not empty product && not empty product.imageUrl ? product.imageUrl : 'images/no-image.png'}" />" />
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="is_active" ${not empty product && product.active ? 'checked' : ''} />
                Aktif
            </label>
        </div>

        <div class="form-actions" style="display: flex; gap: 10px; margin-top: 20px;">
            <button type="submit" class="btn btn-primary">Kaydet</button>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">İptal</a>
        </div>
    </form>
</div>

<jsp:include page="includes/admin-footer.jsp" />
