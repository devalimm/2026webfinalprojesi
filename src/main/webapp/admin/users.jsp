<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="includes/admin-header.jsp" />

<h2 class="page-title">Kullanıcı Yönetimi</h2>

<c:if test="${not empty error}">
    <div class="alert alert-error"><c:out value="${error}" /></div>
</c:if>

<div class="data-table">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Ad Soyad</th>
                <th>E-posta</th>
                <th>Telefon</th>
                <th>Rol</th>
                <th>Kayıt Tarihi</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty users}">
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td><c:out value="${user.fullName}" /></td>
                            <td><c:out value="${user.email}" /></td>
                            <td><c:out value="${user.phone}" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role == 'admin'}">
                                        <span class="badge" style="background-color: #e74c3c;">Admin</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge" style="background-color: #27ae60;">Müşteri</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${user.createdAt}" pattern="dd.MM.yyyy HH:mm" /></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 30px; color: #7f8c8d;">Henüz kullanıcı bulunmamaktadır.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="includes/admin-footer.jsp" />
