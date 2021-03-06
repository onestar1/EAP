﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Zippy.Data.Collections.PaginatedList<Z10Cabbage.Entity.Z10Order>>" %>

<%@ Import Namespace="Z10Cabbage.Entity" %>
<%@ Import Namespace="Z10Cabbage.Entity.Helper" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	采购退货单
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<script type="text/javascript" src="/content/scripts/pagemvc.js"></script>
	<script type="text/javascript">
		var pageSize = <%=ViewData["PageSize"] %>;
		var controller = "/Z10Move";
		var sortUrl = "<%=Model.ToSortUrl() %>";

		$(function () {
			$("#bQuery").click(function () {
				window.location.href = controller + '/Returned?PageSize=' + pageSize 
					+ "&qCreateDateStart=" + encodeURIComponent($("#qCreateDateStart").val())
					+ "&qCreateDateEnd=" + encodeURIComponent($("#qCreateDateEnd").val());			
			});

			$("#qCreateDateStart").bind("focus click", function(){
				WdatePicker({maxDate:'#F{$dp.$D(\'qCreateDateEnd\')||\'2100-10-01\'}',firstDayOfWeek : 1})
			});

			$("#qCreateDateEnd").bind("focus click", function(){
				WdatePicker({minDate:'#F{$dp.$D(\'qCreateDateStart\')}',maxDate:'2100-10-01',firstDayOfWeek : 1});
			});

			$(".xdetail").unbind("click").bind("click",function(){
				var id = $(this).attr("rel");
				parent.go2(controller + "/Detail/" + id);
			});
            $(".xterms").click(function(){
				var id = $(this).attr("rel");
				parent.go2(controller + "/Terms/" + id);
            });
            $(".xputout").click(function () {
                var id = $(this).attr("rel");
                parent.go2(controller + "/PutOut/" + id);
            });
            $(".xputin").click(function () {
                var id = $(this).attr("rel");
                parent.go2(controller + "/PutIn/" + id);
            });
		});
	</script>
	<div id="contents">
		<div id="top">
			<div class="con clearfix">
				<div class="fl">
					<%=ViewData["TopMenu"] %>
				</div>
			</div>
		</div>
		<div id="main">
			<%
				var orCol = Request["orderCol"];
				int iorCol = orCol.ToInt32();
			%>
			<table cellspacing="0" cellpadding="0" border="0" rel="main" class="list-table">
				<tr rel="title">
					<th width="20">
						<input type="checkbox" rel="check" />
					</th>
					<th>
						订单编号
						<% if (iorCol == 1)
						   { %>
						<i title="点击排序" class="icon i_sort i_asc" rel="2"></i>
						<%}
						   else if (iorCol == 2)
						   { %>
						<i title="点击排序" class="icon i_sort i_desc" rel="1"></i>
						<%}
						   else
						   { %>
						<i title="点击排序" class="icon i_sort i_nosort" rel="1"></i>
						<%} %>
					</th>
					<th>
						出库仓库
						<% if (iorCol == 3)
						   { %>
						<i title="点击排序" class="icon i_sort i_asc" rel="4"></i>
						<%}
						   else if (iorCol == 4)
						   { %>
						<i title="点击排序" class="icon i_sort i_desc" rel="3"></i>
						<%}
						   else
						   { %>
						<i title="点击排序" class="icon i_sort i_nosort" rel="3"></i>
						<%} %>
					</th>
					<th>
						入库仓库
						<% if (iorCol == 5)
						   { %>
						<i title="点击排序" class="icon i_sort i_asc" rel="6"></i>
						<%}
						   else if (iorCol == 6)
						   { %>
						<i title="点击排序" class="icon i_sort i_desc" rel="5"></i>
						<%}
						   else
						   { %>
						<i title="点击排序" class="icon i_sort i_nosort" rel="5"></i>
						<%} %>
					</th>
					<th>
						出货时间
						<% if (iorCol == 7)
						   { %>
						<i title="点击排序" class="icon i_sort i_asc" rel="8"></i>
						<%}
						   else if (iorCol == 8)
						   { %>
						<i title="点击排序" class="icon i_sort i_desc" rel="7"></i>
						<%}
						   else
						   { %>
						<i title="点击排序" class="icon i_sort i_nosort" rel="7"></i>
						<%} %>
					</th>
					<th>状态</th>
					<th>
						创建时间
						<% if (iorCol == 11)
						   { %>
						<i title="点击排序" class="icon i_sort i_asc" rel="12"></i>
						<%}
						   else if (iorCol == 12)
						   { %>
						<i title="点击排序" class="icon i_sort i_desc" rel="11"></i>
						<%}
						   else
						   { %>
						<i title="点击排序" class="icon i_sort i_nosort" rel="11"></i>
						<%} %>
					</th>
					<th style="width:140px">操作</th>
				</tr>
				<%var db = ViewData["db"] as Zippy.Data.IDalProvider; %>
				<%
					if (Model.Count > 0)
					{
						foreach (var item in Model)
						{
						
				%>
				<tr rel="item">
					<td class="tc">
						<input type="checkbox" value="<%=item.OrderID %>" name='checkID' class="xID" />
					</td>
					<td>
						<%=DateTime.Now.ToString("yyyyMMddHH") + item.OrderID%>
					</td>
					<td>
						<% var depot = item.GetTop1OrderItem(db).GetDepot(db);
                         if (depot != null)
                             Response.Write(depot.Title);
                        %>
					</td>
					<td>
						<% var depot2 = item.GetTop1OrderItem(db).GetDepot2(db);
                         if (depot2 != null)
                             Response.Write(depot2.Title);
                        %>
					</td>
					<td>
						<%if (item.DateShip != null)
						  {
							  Response.Write(item.DateShip.Value.ToString("yyyy-MM-dd"));
						  }
						  else
						  {
							  Response.Write("还没有出货");
						  }
						%>
					</td>
					<td><%=(typeof(EAP.Logic.Z10.OrderStatus)).ToString(item.OrderStatus ?? 0, typeof(Resources.X)) %></td>
					<td>
						<%=item.CreateDate.Value.ToPassedAway()%>
					</td>
					<td>
                        <a href="javascript:" class="list" id="action_<%=item.OrderID %>">操作</a>
                        <div>
                        <ul class="opt-mmenu" rel="action_<%=item.OrderID %>">
                            <li><i class="icon i_detail"></i><a href="javascript:" rel="<%=item.OrderID %>" class="xdetail" rel="<%=item.OrderID %>">详情</a></li>
                        <% 
                            var innedsome = false;
                            if (((item.OrderStatus ?? 0) & (int)EAP.Logic.Z10.OrderStatus.Inned) == (int)EAP.Logic.Z10.OrderStatus.Inned &&
                                ((item.OrderStatus ?? 0) & (int)EAP.Logic.Z10.OrderStatus.InnedSome) == (int)EAP.Logic.Z10.OrderStatus.InnedSome)
                            {
                                innedsome = true; 
                            }
                            
                            var inned = ((item.OrderStatus ?? 0) & (int)EAP.Logic.Z10.OrderStatus.Inned) == (int)EAP.Logic.Z10.OrderStatus.Inned;
                            var outtedsome = false;

                            if (((item.OrderStatus ?? 0) & (int)EAP.Logic.Z10.OrderStatus.Outted) == (int)EAP.Logic.Z10.OrderStatus.Outted &&
                                ((item.OrderStatus ?? 0) & (int)EAP.Logic.Z10.OrderStatus.OuttedSome) == (int)EAP.Logic.Z10.OrderStatus.OuttedSome)
                            {
                                outtedsome = true;
                            }

                            var outted = ((item.OrderStatus ?? 0) & (int)EAP.Logic.Z10.OrderStatus.Outted) == (int)EAP.Logic.Z10.OrderStatus.Outted;
                            var finished = ((item.OrderStatus ?? 0) & (int)EAP.Logic.Z10.OrderStatus.Finished) == (int)EAP.Logic.Z10.OrderStatus.Finished;

                            if (!finished)
                            {
                        %>
                            <%
                                if (!innedsome && !inned && !outtedsome && !outted)
                                {
                            %>
                                <li><i class="icon i_edit"></i><a href="javascript:;" rel="<%=item.OrderID %>" class="xedit">修改</a></li>
                                <li><i class="icon i_del"></i><a href="javascript:;" rel="<%=item.OrderID %>" class="xdel">删除</a></li>
                                <li><i class="icon i_terms"></i><a href="javascript:;" rel="<%=item.OrderID %>" class="xterms">附加条款</a></li>
                                <li><i class="icon i_putin"></i><a href="javascript:;" rel="<%=item.OrderID %>" class="xputin">入库</a></li>
                                <li><i class="icon i_putout"></i><a href="javascript:;" rel="<%=item.OrderID %>" class="xputout">出库</a></li>
                            <%
                                }
                                else
                                {
                                    if (!inned)
                                        Response.Write("<li><i class=\"icon i_putin\"></i><a href=\"javascript:;\" rel=\"" + item.OrderID + "\"  class=\"xputin\">入库</a></li>");
                                    else if (innedsome)
                                        Response.Write("<li><i class=\"icon i_putin\"></i><a href=\"javascript:;\" rel=\"" + item.OrderID + "\"  class=\"xputin\">入库</a></li>");

                                    if (!outted)
                                        Response.Write("<li><i class=\"icon i_putout\"></i><a href=\"javascript:;\" rel=\"" + item.OrderID + "\"  class=\"xputout\">出库</a></li>");
                                    else if (outtedsome)
                                        Response.Write("<li><i class=\"icon i_putout\"></i><a href=\"javascript:;\" rel=\"" + item.OrderID + "\"  class=\"xputout\">出库</a></li>");
                                }
                            }
                        %>
                        </ul>
                        </div>
					</td>
				</tr>
				<%
					}
					}
					else
					{ %>
				<!-- 没有数据的时候显示 -->
				<tr rel="noitem">
					<td colspan="8" class="msg-box h200">
						没有任何数据
					</td>
				</tr>
				<!-- 没有数据的时候显示 -->
				<%} %>
			</table>
		</div>
	</div>
	<div class="pop-box pop-query w600" rel="search" style="z-index:999">
		<div class="con">
			<a rel="close" class="close mr10" href="javascript:;">关闭</a>
			<div class="msg-box msg-contents">
				<table class="query">
					<tr>
						<td class='tt'>
							创建时间：
						</td>
						<td>
							<input type='text' class='text' id='qCreateDateStart' />
						</td>
						<td>
						</td>
					</tr>
				</table>
			</div>
			<div class="bottom">
				<a class="jenter button" href="javascript:;" id='bShowAll'>显示全部<b></b></a> <a class="jenter button active"
					href="javascript:;" id='bQuery'>查询<b></b></a>
			</div>
		</div>
	</div>

	<div id="bottom">
		<%=Model.ToPagerHtml() %>
	</div>
</asp:Content>