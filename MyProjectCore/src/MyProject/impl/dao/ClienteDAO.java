package MyProject.impl.dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.swing.JOptionPane;

import MyProjectDominio.Cartao;
import MyProjectDominio.Cliente;
import MyProjectDominio.Endereco;
import MyProjectDominio.EntidadeDominio;
import MyProjectDominio.Livro;
import MyProjectDominio.Pedido;


public class ClienteDAO extends AbstractJdbcDAO {

		public ClienteDAO() {
		super("Nome", " ID");
		
	}
	@Override
	
	public void salvar(EntidadeDominio entidade) throws SQLException {
		openConnection();
		PreparedStatement pst = null;		
		Cliente cliente = (Cliente)entidade;
		try {
			connection.setAutoCommit(false);	
			StringBuilder sql = new StringBuilder();
			sql.append("INSERT INTO Clientes( Nome, Dt_nasc, Dt_Cadastro, CPF, Genero, Tipo_tel, Telefone, Email, senha, status) ");
			sql.append("VALUES (?,?,sysdate(),?,?,?,?,?,?,?)");
					
			pst = connection.prepareStatement(sql.toString());
			pst.setString(1, cliente.getNome());
			Timestamp time = new Timestamp(cliente.getDt_nasc().getTime());
			pst.setTimestamp(2, time);
			pst.setString(3, cliente.getCpf());
			pst.setString(4, cliente.getGenero());
			pst.setString(5, cliente.getTipo_tel());
			pst.setString(6, cliente.getTelefone());
			pst.setString(7, cliente.getEmail());
			pst.setString(8, cliente.getSenha());
			pst.setBoolean(9,cliente.getStatus());
			pst.executeUpdate();			
			connection.commit();
		} catch (SQLException e) {
			try {
				connection.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();			
		}finally{
			try {
				pst.close();
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	

	@Override
	public void alterar(EntidadeDominio entidade) throws SQLException {
		openConnection();
		PreparedStatement pst = null;
		Cliente cliente = (Cliente)entidade;
		
		try {
			connection.setAutoCommit(false);
			StringBuilder sql = new StringBuilder();
			sql.append("UPDATE Clientes SET Nome=?, Dt_nasc=?, CPF=?, Genero=?, Tipo_tel=?, Telefone=?, Email=?, senha=?, status=?,");
			sql.append(" WHERE ID_Cliente=?");
			
			pst = connection.prepareStatement(sql.toString());
			pst.setString(1, cliente.getNome());
			Timestamp time = new Timestamp(cliente.getDt_nasc().getTime());
			pst.setTimestamp(2, time);
			pst.setString(3, cliente.getCpf());
			pst.setString(4, cliente.getGenero());
			pst.setString(5, cliente.getTipo_tel());
			pst.setString(6, cliente.getTelefone());
			pst.setString(7, cliente.getEmail());
			pst.setString(8, cliente.getSenha());
			pst.setBoolean(9,cliente.getStatus());
			pst.setInt(10,cliente.getId());
			System.out.println(cliente.getNome());
			pst.executeUpdate();			
			connection.commit();
			System.out.println("Burguesinha");
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		
	}

	@Override
	public List<EntidadeDominio> consultar(EntidadeDominio entidade) throws SQLException {
		PreparedStatement pst = null;
		Cliente cliente = (Cliente) entidade;
		StringBuilder sql = new StringBuilder();

		sql.append( "SELECT * FROM clientes where 1=1 ");
		if (cliente.getId()!= null) {
			sql.append("AND ID_Cliente = '" + cliente.getId() + "'");
			
		}
		try {
			openConnection();
			pst = connection.prepareStatement(sql.toString());
			System.out.println(sql.toString());
			ResultSet rs = pst.executeQuery();
			List<EntidadeDominio> clientes = new ArrayList<EntidadeDominio>();
			
			
			
				while(rs.next()){
					Cliente c = new Cliente();
					c.setId(rs.getInt("ID_cliente"));
					c.setGenero(rs.getString("Genero"));
					c.setEmail(rs.getString("Email"));
					c.setNome(rs.getString("Nome"));
					c.setDt_nasc(rs.getDate("Dt_nasc"));
					c.setCpf(rs.getString("Cpf"));
					c.setTipo_tel(rs.getString("Tipo_tel"));
					c.setTelefone(rs.getString("Telefone"));
					c.setStatus(rs.getBoolean("status"));
					c.setDt_Cadastro(rs.getDate("Dt_Cadastro"));
					
					pst = connection.prepareStatement("SELECT * FROM endereco where fk_cliente = " + c.getId());					
					ResultSet rse = pst.executeQuery();
					List<Endereco> enderecos = new ArrayList<Endereco>();
					while(rse.next()){
						Endereco e = new Endereco();
						e.setBairro(rse.getString("bairro"));
						e.setCep(rse.getString("CEP"));
						e.setCidade(rse.getString("bairro"));
						e.setEstado(rse.getString("cidade"));
						e.setLogradouro(rse.getString("logradouro"));
						e.setNumero(rse.getString("numero"));
						e.setPais(rse.getString("pais"));
						e.setObs(rse.getString("obs"));
						e.setId(rse.getInt("ID_Endereco"));
						e.setTipo_log(rse.getString("tipo_Logradouro"));
						e.setTipo_res(rse.getString("tipo_Residencia"));
						enderecos.add(e);						
					}
					c.setEndereco(enderecos);					
					clientes.add(c);
					
					pst = connection.prepareStatement("SELECT * FROM cartao WHERE pk_cliente = " + c.getId());
					ResultSet cartoesCliente = pst.executeQuery();
					List<Cartao> cartoes = new ArrayList<Cartao>();
					while(cartoesCliente.next())
					{
						Cartao cr = new Cartao();
						
						cr.setId(cartoesCliente.getInt("id_cartao"));
						cr.setBandeira(cartoesCliente.getString("bandeira"));
						cr.setNumero(cartoesCliente.getString("numero"));
						cr.setCodigo(cartoesCliente.getString("codigo_seg"));
						cr.setValidade(cartoesCliente.getString("dtVencimento"));
						cr.setID_Cliente(cartoesCliente.getInt("pk_cliente"));
						cartoes.add(cr);
					}				
					c.setCartao(cartoes);					
					clientes.add(c);
					
					PediDAO daoPedido = new PediDAO();
					Pedido pedi = new Pedido();
					pedi.setIDusuario(c.getId());
					List<EntidadeDominio> pedidos = daoPedido.consultar(pedi);
					if(pedidos != null)
					{
						List<Pedido> listaPedidos = new ArrayList<Pedido>();
						for(int i = 0; i < pedidos.size(); i++)
						{
							pedi = (Pedido)pedidos.get(i);
							listaPedidos.add(pedi);
						}
						c.setPedido(listaPedidos);
					
					}
					

				}
				return clientes;
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return null;
	}

}
