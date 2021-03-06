<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<script type="text/javascript" src="js/jquery-1.6.2.js"></script>

<script type="text/javascript">
	function deleteItem(id) {
		var url = "${deleteItem}?productID=" + id;
		var OK = confirm('proceed?');
		if (OK) {
			window.location = url;
		}
	}

	$(document).ready(function() {
		$('#field').change(function() {
			processSearch();
		});

		var timer = null;

		$('#searchField').keyup(function() {
			clearTimeout(timer);
			timer = setTimeout(function() {
				processSearch();
			}, 500);
		});
	});

	function processSearch() {
		var data = $('#searchForm').serialize();
		$.getJSON('productsAJAX.htm', data, function(response) {
			$("#table").find("tr:gt(0)").remove();
			var records = response.records;

			$.each(records, function() {
				var newRow = "<tr>";

				newRow += "<td>" + this.productName + "</td>";
				newRow += "<td>" + this.productDescription + "</td>";
				newRow += "<td>" + this.productPrice + "</td>";
				newRow += "</tr>";

				$("#table").append(newRow);
			});

			$('#recordsFound').html(response.recordsFound);
			$('#pageNumber').html(response.page);
			$('#pageCount').html(response.pageCount);

			var pageNumber = response.page * 1;
			var pagesCount = response.pageCount * 1;

			if (pageNumber == 1) {
				$('#first').attr('disabled', 'disabled');
				$('#previous').attr('disabled', 'disabled');
			} else {
				$('#first').removeAttr('disabled');
				$('#previous').removeAttr('disabled');
			}

			if (pageNumber == pagesCount) {
				$('#last').attr('disabled', 'disabled');
				$('#next').attr('disabled', 'disabled');
			} else {
				$('#last').removeAttr('disabled');
				$('#next').removeAttr('disabled');
			}
		});
	}
</script>

<div id="list">
	<h2>
		<spring:message code="users.h2" />
	</h2>

	<a href="${getPDF}" style="color: blue;" target="_blank"><spring:message code="report.save" />
	</a>

	<%@include file="itemsSearch.jsp"%>

	<table id="table">
		<thead>
			<tr>
				<th style="width: 25%"><a href="${itemSort}?propertyName=productName"><spring:message
							code="im.Name" />
				</a>
				</th>
				<th style="width: 35%;"><a href="${itemSort}?propertyName=productDescription"><spring:message
							code="im.Description" /> </a>
				</th>
				<th style="width: 20%"><a href="${itemSort}?propertyName=productPrice"><spring:message
							code="im.Price" /> </a>
				</th>
			</tr>
		</thead>

		<c:forEach items="${products}" var="product">
			<tr>
				<td>${product.productName}</td>
				<td>${product.productDescription}</td>
				<td>${product.productPrice}</td>
			</tr>
		</c:forEach>
	</table>

	<%@include file="itemsNavigation.jsp"%>
</div>