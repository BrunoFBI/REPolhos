<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="MyProjectCore.aplicacao.Resultado, MyProjectDominio.*, java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>


<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
	integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
	crossorigin="anonymous"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"
	integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4"
	crossorigin="anonymous"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js"
	integrity="sha384-h0AbiXch4ZDo7tp9hKZ4TsHbi047NrKGLO3SEJAg45jXxnGIfYzk4Si90RDIqNm1"
	crossorigin="anonymous"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css"
	integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M"
	crossorigin="anonymous">
<title>Seu carrinho</title>
<script>
	function Redirecionar(qtde, id) {
		window.location.href = "SalvarCarrinho?operacao=MUDAR&qtde=" + qtde
				+ "&id=" + id;
		document.getElementById("numerim").value = qtde;
	}
</script>
<script>
	function PedirLogin() {
		document.getElementById("iLogin").style.display = '';

	}
	
	function FrameEnd() {
		document.getElementById("Iendereco").style.display = '';

	}
</script>
<script>
	function PegaIdEndereco(idEnd){
		document.getElementById("idbacana").value = idEnd;
	}


</script>
</head>
<body>

	<%
		
		Cupom cup = (Cupom) request.getSession().getAttribute("cupom");
		Cliente c = (Cliente) request.getSession().getAttribute("usuario");
		
		String stringId = (String) request.getSession().getAttribute("userid");
		
		if (stringId == null) {
			stringId = "0";
		}
		
		if (stringId != null) {
			if (!stringId.trim().equals("0")) {
				if (request.getSession().getAttribute("usuariodeslogado") != null) {
					Map<Integer, Pedido> mapaUsuarios = (Map<Integer, Pedido>) request.getSession().getAttribute("mapaUsuarios");
					Pedido p = mapaUsuarios.get(0);
					mapaUsuarios.put(Integer.parseInt(stringId), p);
					mapaUsuarios.remove(0);
					request.getSession().removeAttribute("usuariodeslogado");
					request.getSession().setAttribute("mapaUsuarios", mapaUsuarios);
				}
			}
		}
		if (request.getSession().getAttribute("redirecionar") == null) {
			request.getSession().setAttribute("redirecionar", "1");
			response.sendRedirect("Carrinho.jsp");
			return;
		}
		
		request.getSession().setAttribute("redirecionar", null);
		Map<Integer, Pedido> map = (Map<Integer, Pedido>) request.getSession().getAttribute("mapaUsuarios");
		Resultado cupom = (Resultado) request.getSession().getAttribute("resultadoCupom");
		Resultado res = (Resultado) request.getSession().getAttribute("resultadoLivro");
		List<Unidade> unidade = new ArrayList<Unidade>();
		String usuario = (String) request.getSession().getAttribute("pedShow");
	%>
	<%
		Cliente cli = (Cliente) session.getAttribute("usuario");
	%>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container">
		<a class="navbar-brand"
			href="http://localhost:8080/MyProjectWeb/Index.jsp">Hyper Books</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarResponsive" aria-controls="navbarResponsive"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarResponsive">
			<ul class="navbar-nav ml-auto">
				<li class="nav-item active"><a class="nav-link" href="#">Home
						<span class="sr-only">(current)</span>
				</a></li>
				<li class="nav-item"><a class="nav-link" href="#">Sobre</a></li>
				<li class="nav-item"><a class="nav-link" href="#">Servi�os</a>
				</li>
				<%
					if (cli == null) {
						StringBuilder sb = new StringBuilder();
						sb.append("<li class='nav-item'>");
						sb.append(" <a class='nav-link' href='http://localhost:8080/MyProjectWeb/Login.jsp'>");
						sb.append("Login");
						out.print(sb.toString());
					} else {
						StringBuilder sb = new StringBuilder();
						sb.append("<li class='nav-item'>");
						sb.append(" <a class='nav-link' href='DeslogarCliente?operacao=DESLOGAR'>");
						sb.append("Logout");
						out.print(sb.toString());
					}
				%>
				</a>
				</li>
				<li class="nav-item"><a class="nav-link"
					href="http://localhost:8080/MyProjectWeb/SalvarCarrinho">Carrinho</a>

				</li>
			</ul>
		</div>
	</div>
	</nav>
	<br>
	<br>
	<br>
	<div class="container">
		<div class="row">
			<div class="col-sm-12 col-md-10 col-md-offset-1">
				<table class="table table-striped table-dark"">
					<thead>
						<tr>
							<th>Produto</th>
							<th>Quantidade</th>
							<th>Pre�o</th>
							<th style="padding-left: 84px;">Total</th>
							<%
								if (res != null) {
									if (res.getMsg() == null) {
										out.print("<td> </td>");
									} else
										out.print(res.getMsg());
								}
							%>
						</tr>
					</thead>
					<%
						double subTotal = 0;					
						double precoTotal = 0;
						double precoFrete = 0;
						double totalzao = 0;
						double full = 0;
						if (map != null) {
							String txtId = (String) request.getSession().getAttribute("userid");
							int id = Integer.parseInt(txtId);
							//Map<Integer, Resultado> mapaResultado = (Map<Integer, Resultado>)request.getSession().getAttribute("mapaResultado");
							StringBuilder sb = new StringBuilder();
							Pedido p = map.get(id);
							if( p == null){
							 System.out.println(" PEDIDO NULO!!!!");
							}
							unidade = p.getUnidade();
							p.setQtdItens(0);
							if (unidade.size() != 0) {
								for (int i = 0; i < unidade.size(); i++) {
									p.setQtdItens(i + 1);
									System.out.println(" Quantidade de itens: " + p.getQtdItens());
									sb.setLength(0);
									Unidade uni = unidade.get(i);
									Livro l = uni.getLivro();
									sb.append("<tbody>");
									sb.append("<tr>");
									sb.append("<td class='col-sm-8 col-md-6'>");
									sb.append("<div class='media'>");
									sb.append("<div class='media-body'>");
									sb.append("<h4 class='media-heading'><a href='#''>");
									sb.append(l.getTitulo());
									sb.append("</a></h4>");
									sb.append("</div>");
									sb.append("</div></td>");
									// Pega titulo do livro na lista
									sb.append("<td data-th='Quantity'>");
									sb.append("<input type='number' max='" + l.getQuantidade()
											+ "' min='1' class='form-control' value='" + uni.getQuantidade()
											+ "' id='numerim' onchange='Redirecionar(this.value," + l.getId() + ")'>");
									// input qye chama a fun��o de redirecionamento cada vez que � alterada   
									sb.append("</td>");
									sb.append("</td>");
									sb.append("<td class='col-sm-1 col-md-1 text-center'><strong>");
									sb.append(l.getValor());
									System.out.println(l.getValor());
									sb.append("<td class='col-sm-1 col-md-1 text-center'><strong>");
									sb.append(l.getValor() * uni.getQuantidade());
									sb.append("</strong></td>");
									sb.append("<td class='col-sm-1 col-md-1'>");
									sb.append("<a href='SalvarCarrinho?operacao=REMOVER&id=" + l.getId() + "'>");
									sb.append("<button class='btn btn-danger'>REMOVER</button>");
									sb.append("</a>");
									sb.append("</td>");
									sb.append("</tr>");
									sb.append("</tbody>");
									totalzao = l.getValor() * uni.getQuantidade();
									precoTotal = totalzao + precoTotal;
									precoFrete = (uni.getQuantidade() *12) + p.getQtdItens() ;
									out.print(sb.toString());
									/////////////////////////////////////////////////////////////////
									String titulo = l.getTitulo();
								}

							}
						}
					%>
					<%
						if (map != null) {
							String txtId = (String) request.getSession().getAttribute("userid");
							int id = Integer.parseInt(txtId);				
							StringBuilder sb = new StringBuilder();
							Pedido p = map.get(id);
							System.out.println("Sou uma ID: " + id);		
							unidade = p.getUnidade();
							p.setPrecoFrete(precoFrete);
							p.setPrecoTotal(precoTotal);
							p.setPrecoFinal(precoFrete + precoTotal);
							if (cup != null) {
								if (cupom.getMsg() == null) {
									p.setPrecoFinal(precoFrete + precoTotal - cup.getDesconto());
																						
								} else {
									p.setPrecoFinal(precoFrete + precoTotal);
								}

								if (p.getPrecoFinal() < 0) {
									p.setPrecoFinal(0);
								}
								if (p.getQtdItens() == 0) {
									request.getSession().removeAttribute("cupom");
								}
							}
							sb.append("<tfoot>");
							sb.append(" <tr>");
							sb.append(" <td><h5>Total<br>Frete</h5><h3>Final</h3></td>");
							sb.append("<td class='text-right'><h5><strong>");
							sb.append(p.getPrecoTotal() + "<br>");
							sb.append(p.getPrecoFrete());
							sb.append("</strong></h5><h3>");
							sb.append(p.getPrecoFinal());
							sb.append("</h3></td>");
							out.print(sb.toString());
							
							precoTotal = p.getPrecoTotal();
						}
					%>

					<tr>
						<form action="SalvarCupom" method="post">
							<td><input type="submit" id="operacao" name="operacao"
								value="CUPONIZAR" class="btn btn-success" /></td>
							</td>
							<td><input type="text" id="txtCupom" name="txtCupom"
								style="margin-right: 30px"></td>
						</form>						
						<td></td>
						<td><a href="http://localhost:8080/MyProjectWeb/Index.jsp"
							type="button" class="btn btn-default"> Continuar Comprando </a>
						</td>
						
						<%
							if (cli == null) {
								StringBuilder sb = new StringBuilder();
								sb.append(
										"<td><button type='button' class='btn btn-success' id='finalizar' name='finalizar' onclick='PedirLogin();'>");
								sb.append("FINALIZAR");
								sb.append("</button>");
								out.print(sb.toString());
							} else {
								String txtId = (String) request.getSession().getAttribute("userid");				
								if(cli.getEndereco().size() > 0){
									StringBuilder sb = new StringBuilder();
									sb.append("<form method='post' action='FinalizaCompras'>");
									sb.append("<td><button type='submit' class='btn btn-success' id='operacao' name='operacao' value='FINALIZAR'>");
									sb.append("FINALIZAR");
									sb.append("</button>");
									sb.append("<input type='hidden' name ='idbacana' id='idbacana'/>");
									sb.append("<input type='hidden' name ='precototal' value='"+precoTotal+"' id='precototal'/>");
									sb.append("<input type='hidden' name ='titulo' value='Harry Potter' id='titulo'/>");
									sb.append("</form>");
									out.print(sb.toString());							
								}
								else{
									StringBuilder sb = new StringBuilder();
									sb.append("<form method='post' action='FinalizaCompras'>");
									sb.append("<td><button type='submit' class='btn btn-success' id='operacao' name='operacao' value='FINALIZAR' disabled>");
									sb.append("FINALIZAR");
									sb.append("</button>");
									sb.append("<input type='hidden' name ='idbacana' id='idbacana'/>");
									sb.append("</form>");
									out.print(sb.toString());			
									
								}
							}
						%>
					
						</td>
						</td>
						<td></td>
						<td>
						<td></td>
						<td></td>
					</tr>
					</tfoot>
				</table>
				<% 
					Cupom cupo = (Cupom) request.getSession().getAttribute("cupom");
				if(cupo != null){
					if (cupom.getMsg() == null) {
								StringBuilder st = new StringBuilder();							
								st.append("<div class='alert alert-success' role='alert'>");
								st.append("<strong>Parab�ns</strong> Cupom inserido com sucesso.");
								st.append("</div>");	
								out.print(st.toString());	
																							
								} 
					else{
						StringBuilder st = new StringBuilder();							
						st.append("<div class='alert alert-danger' role='alert'>");
						st.append("<strong>OPS!</strong> Tem algo errado com seu Cupom!.");
						st.append("</div>");	
						out.print(st.toString());	
					}
						
						}
						
					%>
					<%
						if(cli !=null){
							if(cli.getEndereco().size() == 0)
								{
									System.out.println("Sou uma parte do endereco" + cli.getEndereco());
									StringBuilder st  =  new StringBuilder();
									 st.append(" <button class='btn btn-info' onclick='FrameEnd();'> Cadastre seu endere�o para finalizar a compra </button>'" );
									 out.print(st.toString());	
								}
								else if(cli.getEndereco().size() > 0)
								{
									System.out.println("Sou uma parte do endereco" + cli.getEndereco());
									StringBuilder st  =  new StringBuilder();
									 st.append(" <button class='btn btn-info' data-toggle='modal' data-target='#exampleModal' data-whatever=''@mdo'> Selecione o endereco de entrega </button>'" );
									 out.print(st.toString());	
								}
							
							else{
								StringBuilder st  =  new StringBuilder();
								 out.print(st.toString());	
							}
							
						}
					%>
				<div class="embed-responsive embed-responsive-16by9">
					<iframe class="embed-responsive-item" id="iLogin" name="iLogin"
						src="http://localhost:8080/MyProjectWeb/FakeLogin.jsp"
						style="display: none; width:200px;"></iframe>
						<iframe class="embed-responsive-item" id="Iendereco" name="Iendereco"
						src="http://localhost:8080/MyProjectWeb/FakeEnd.jsp"
						style="display: none;"></iframe>
				</div>
<!-- ----------------------------------------- AREA DE FINALIZA��O DE COMPRAS---------------------------------------------------------------------------------------------------------->

 
 
 
 
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel" style="margin-left:18%" >Selecione o Endere�o de entrega </h5>
      </div>
      <div class="modal-body">
        <form>							
		<table class="table table-striped table-dark table-responsive" style="width: 450px">
		<tr>
		<td><b> Rua</b></td>
		<td><b> Num</b></td>
		<td><b> Preferencial</b></td>
		</tr>
            <%
			if(cli != null)
			{
				StringBuilder st = new StringBuilder();
				
				for(int k = 0; k < cli.getEndereco().size(); k++){
					st.append("<tr>");
					st.append("<td><li>");
					st.append(cli.getEndereco().get(k).getLogradouro());
					st.append("</li></td>");			
					st.append("<td>");
					st.append(cli.getEndereco().get(k).getNumero());;	
					st.append("</td>");
					st.append("<td>");
					st.append("<input type='radio' class='btn btn-primary btn-sm'  id='EndID' value='"+	k +"' onclick='PegaIdEndereco(this.value)'></input>");
					st.append("</td>");	
					st.append("</tr>");				
			}								
				st.append("</table>");	
				st.append("</div>");
				out.print(st.toString());
				
			}								
		%>	
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

			
			
			</div>
		</div>
	</div>
</body>
</html>