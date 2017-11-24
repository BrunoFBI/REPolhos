package MyProjectDominio;

import java.util.List;
import java.util.Date;
public class Pedido extends EntidadeDominio{
	private List<Unidade> unidade;
	private Date dtPedido;
	private String status;
	private Cliente usuario;
	private double precoTotal;
	
	public double getPrecoTotal() {
		return precoTotal;
	}
	public void setPrecoTotal(double precoTotal) {
		this.precoTotal = precoTotal;
	}
	public Cliente getUsuario() {
		return usuario;
	}
	public void setUsuario(Cliente usuario) {
		this.usuario = usuario;
	}
	public List<Unidade> getUnidade() {
		return unidade;
	}
	public void setUnidade(List<Unidade> unidade) {
		this.unidade = unidade;
	}
	public Date getDtPedido() {
		return dtPedido;
	}
	public void setDtPedido(Date dtPedido) {
		this.dtPedido = dtPedido;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}