package MyProject.web.vh.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import MyProject.web.vh.IViewHelper;
import MyProjectCore.aplicacao.Resultado;
import MyProjectDominio.Cliente;
import MyProjectDominio.Endereco;
import MyProjectDominio.EntidadeDominio;
import jdk.nashorn.internal.ir.RuntimeNode.Request;

public class EnderecoViewHelper implements IViewHelper {

	@Override
	public EntidadeDominio getEntidade(HttpServletRequest request) {
		
		Cliente cu = (Cliente) request.getSession().getAttribute("usuario");	
		String operacao = request.getParameter("operacao");
		Endereco endereco = null;
		
		if(!operacao.equals("VISUALIZAR"))
		{
			
			String cep = request.getParameter("txtCep");
			String estado = request.getParameter("txtEstado");
			String cidade = request.getParameter("txtCidade");
			String pais = request.getParameter("txtPais");
			String obs = request.getParameter("txtObservacao");
			String tipo_res = request.getParameter("txtTipoResidencia");
			String tipo_log = request.getParameter("txtLogradouro");
			String logradouro = request.getParameter("txtLogradouro");
			String numero = request.getParameter("txtNumero");
			String bairro = request.getParameter("txtBairro");
			endereco = new Endereco();
			
			int id = cu.getId();
			endereco.setCli_id(id);
			endereco.setTipo_res(tipo_res);
			endereco.setTipo_log(tipo_log);
			endereco.setLogradouro(logradouro);
			endereco.setNumero(numero);
			endereco.setBairro(bairro);
			endereco.setCep(cep);
			endereco.setEstado(estado);
			endereco.setCidade(cidade);
			endereco.setPais(pais);
			endereco.setObs(obs);
			
			Cliente cli = (Cliente) request.getSession().getAttribute("usuario");
			cli.getEndereco().add(endereco);
			
		
			return endereco;
		}
		else{
			
			HttpSession session = request.getSession();
			Resultado resultado = (Resultado) session.getAttribute("resultado");
			int txtId = Integer.parseInt(request.getParameter("txtId"));
			
			for(EntidadeDominio c: resultado.getEntidades()){
				if(c.getId() == txtId){
					endereco = (Endereco)c;
				}
			}
		}
		return endereco;
	}

	@Override
	public void setView(Resultado resultado, HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		RequestDispatcher d= null;
		request.getSession().setAttribute("resultado", null);
		request.getSession().setAttribute("endereco", null);
		
		String operacao = request.getParameter("operacao");
		
		if(resultado.getMsg() == null){
			if(operacao.equals("SALVAR")){
				resultado.setMsg("Endere�o cadastrado com sucesso!");
			}
			request.getSession().setAttribute("resultado", resultado);
			 String nome = request.getParameter("local");
				System.out.println("Eu sou o nome:" + nome);
				if( nome != null) {
					d = request.getRequestDispatcher("Carrinho.jsp");
					d.forward(request, response);
					return;
				}
				else {
					d = request.getRequestDispatcher("Index.jsp");
				}
			d= request.getRequestDispatcher("ConsultarEndereco.jsp");  			
		}
		
		if(resultado.getMsg() == null && operacao.equals("ALTERAR")){
			
			d= request.getRequestDispatcher("ConsultarEndereco.jsp");  
		}
		
		if(resultado.getMsg() == null && operacao.equals("VISUALIZAR")){
			
			request.setAttribute("cliente", resultado.getEntidades().get(0));
			d= request.getRequestDispatcher("EndCliente.jsp");  
		}
		
		if(resultado.getMsg() == null && operacao.equals("EXCLUIR")){
			
			request.getSession().setAttribute("resultado", null);
			d= request.getRequestDispatcher("ConsultarEndereco.jsp");  
		}
		
		if(resultado.getMsg() != null){
			if(operacao.equals("SALVAR") || operacao.equals("ALTERAR")){
				request.getSession().setAttribute("resultado", resultado);
				d= request.getRequestDispatcher("ConsultarEndereco.jsp");  	
			}
		}
		d.forward(request,response);
		
		
	}

}
