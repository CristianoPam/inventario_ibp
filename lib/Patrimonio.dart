class Patrimonio {
  String cod;
  String? img;
  String nSerie;
  String descricao;
  String filial;
  String gBens;
  String empresa;
  String cCusto;
  String localizacao;
  String fornecedor;
  String dataAquisicao;
  String dataGarantia;
  String responsavel;
  String valor;
  String vidaUtil;
  String depreciacao;
  String observacoes;
  

  Patrimonio(
      {required this.cod,
      this.img,
      required this.nSerie,
      required this.descricao,
      required this.filial,
      required this.gBens,
      required this.empresa,
      required this.cCusto,
      required this.localizacao,
      required this.fornecedor,
      required this.dataAquisicao,
      required this.dataGarantia,
      required this.responsavel,
      required this.valor,
      required this.vidaUtil,
      required this.depreciacao,
      required this.observacoes});

  Patrimonio.fromJson(Map<String, dynamic> json)
      : cod = json['cod'],
        img = json['img'],
        filial = json['filial'],
        nSerie = json['nSerie'],
        descricao = json['descricao'],
        gBens = json['gBens'],
        empresa = json['empresa'],
        cCusto = json['cCusto'],
        localizacao = json['localizacao'],
        fornecedor = json['fornecedor'],
        dataAquisicao = json['dataAquisicao'],
        dataGarantia = json['dataGarantia'],
        responsavel = json['responsavel'],
        valor = json['valor'],
        vidaUtil = json['vidaUtil'],
        depreciacao = json['depreciacao'],
        observacoes = json['observacoes'];

  Map<String, dynamic> toJson() {
    return {
      'cod': cod,
      'img': img,
      'nSerie': nSerie,
      'filial': filial,
      'descricao': descricao,
      'gBens': gBens,
      'empresa': empresa,
      'cCusto': cCusto,
      'localizacao': localizacao,
      'fornecedor': fornecedor,
      'dataAquisicao': dataAquisicao,
      'dataGarantia': dataGarantia,
      'responsavel': responsavel,
      'valor': valor,
      'vidaUtil': vidaUtil,
      'depreciacao': depreciacao,
      'observacoes': observacoes,
    };
  }
}
