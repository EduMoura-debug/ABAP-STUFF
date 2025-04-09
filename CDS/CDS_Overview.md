## CDS Model

Os modelos de CDS compreendem as definições de várias tipos de entidades CDS, como visualizações de CDS e entidades abstratas de CDS

Existem diferentes tipos de modelos de visualização CDS

### Views (Também conhecidas como visualizações V1):

• Representam os modelos de visualização CDS originais. 

### Entity Views (Também conhecidas como visualizações V2):

• Representam o sucessor das visualizações V1. Mais possibilidades.
• Em comparação com as visualizações V1, as visualizações V2 não geram uma visualização adicional do ABAP Data Dictionary em sua ação.
• Isso reduz o risco de inconsistências técnicas e melhora o
desempenho geral de ativação.
• Além disso, as visões V2 reforçam mais a modelagem homogênea e aplica verificações de sintaxe mais rigorosas.

### Projection Views:

• Representam uma especialização das entidades de visualização. Seu principal objetivo é a definição de interfaces em seus modelos de CDS subjacentes com um mapeamento modelado da funcionalidade correspondente. Como resultado, as visualizações de projeção restringem a funcionalidade geral das entidades de visualização a meros recursos de projeção. 
• Projeção de uma entidade, de uma composite. Limita a um objeto final, sendo a última camada para expansão de Annottations.

### Transient Views (às vezes também referidas como visualizações V3):

• Definem entidades de visualização CDS sem uma representação direta no sistema de banco de dados SAP HANA.
• Eles atuam como meros modelos de visualização declarativos cujo comportamento em tempo de execução é governado e implementado por componentes de infraestrutura, como o mecanismo analítico.
• Isso implica que você não pode usar visualizações transitórias como fontes de dados para outras visualizações CDS, nem pode selecionar em seu código ABAP.
• Você aprenderá sobre o uso de visualizações transitórias no contexto da implementação de consultas analíticas

## Sintaxes 

As visualizações de CDS definem instruções de seleção, que são aumentadas com informações adicionais de metadados.

```java
/*comentário bloco*/ //comentário comum
//annotations
@AccessControl.authorizationCheck: #MANDATORY //Autenticação de autorizações
@EndUserText.label: 'View Definition' 
//view definition
define view entity Z_ViewDefinition 
   // parameter definition
   with parameters 
     P_SalesOrderType: auart
    //data source of selection with alias name 
    as select from ZI_SalesOrderItem as ITEM
    //join
    left outer to exact one join ZI_SalesOrder as SO 
        on SO.SalesOrder = ITEM. SalesOrder
    //definição de associação
    association [0..1] to ZI_Product as Product on 
        $projection.RenamedProduct = _Product.Product
{
    //projected field as key
    key ITEM.SalesOrder,
    //projected field used in association definition
    key ITEM.Product as RenamedProduct,
    //constante
    abap.char'A' as Constant,
    //calculated field
    concat( ITEM. SalesOrder, ITEM. Product) as CalculatedField,
    //aggregate
    count(*) as NumberOfAggregatedItems,
    //projected association
    ITEM. SalesOrder,
    //association exposure
    _Product
}

//filter conditions based on join partner and parameter 
where
    So.SalesOrderType = $parameters.P_SalesOrderType 
    //aggregation level
group by
    ITEM. SalesOrder,
    ITEM.Product

```

### Campos Chave (Key Fields)

Os campos de visualização do CDS são definidos como campos-chave, adicionando a chave de elemento de sintaxe anterior aos campos. 

Em geral, uma chave do modelo CDS pode ser composta de vários campos chaves. Estes devem ser colocados antes dos campos-não-chave na lista de projeção de visualização do CDS. Além disso, key fields podem ser usados para verificações de consistência (cardinalidade, associações).

Recomenda-se manter a chave mais curta possível. Somente utilize o que você precise.

```java
define view entity ZZI_DLCDS_ORD_IT
  as select from zzdlcdst_ord_it
{
  key sales_order       as SalesOrder,     // Campo-Chave
  key sales_order_item  as SalesOrderItem, // Campo-Chave
      product           as Product,        // Não precisa ser Campo-Chave
}
```

Campos-chave também tem impacto no controle de acesso da CDS, que avaliam as principais definições ao injetar restrições de autorização em instruções selecionadas. São avaliadas por várias estruturas de implementação, que fornecem seus serviços em cima da visualização (herança de chaves).

### Tipos Literais

Os tipos literais permitem que você especifique o tipo técnico ABAP de um valor constante, que você introduz no seu modelo CDS. São campos que não pertencem a fonte.

Para fazer com que um literal simples se torne um literal digitado, você precisa incluir o valor real em marcas de cota únicas e adicionar as informações do tipo como um prefixo.

```java
define view entity Z_ViewWithTypedLiterals
  as select distinct from t000
{
  'Char10'                              as CharacterValue,
  cast( 'Char10' as abap.char(10) )     as CastCharacterValue,
  abap.char 'Char10'                    as TypedCharacterValue,
  cast( abap.char 'Char10' 
        as Char10 preserving type )     as CastTypedCharacterValue,

  1234.56                               as FloatingPointValue,
  abap.fltp'1234.56'                    as TypedFloatingPointValue,
  fltp_to_dec(1234.56 as abap.dec(6,2)) as ConvertedDecimalValue,
  abap.dec'1234.56'                     as TypedDecimalValue,
  abap.dec'001234.5600'                 as TypedDecimalValue2
}
```

### Tipos Simples

Tipos elementares que podem ser utilizados na sua CDS.

```java
@EndUserText.label: 'Teste' 
define type ZGFD_TYPE_CDS_1: abap.lang
```

Tipos podem ter uma hierarquia também, são conhecidos como tipos de multinível.

Dentro da sua CDS, o uso dos tipos simples servem para tipar os campos da View. Além disso, facilitam na modelagem de dados e manutenção de aplicações.

### Condições (Case statement)

Instruções case são usadas para definir cálculos condicionais dentro da sua CDS. Possível definir vários caminhos com os comandos "when-then" e no final da declaração, para exclusão, o "else".

```java
case (SalesOrderType)
    when 'TAF' then 'X'
    when 'OAF' then 'X'
    //when SalesOrderType = 'OAF' then 'X'
    //when SalesOrderType = 'TAF' or SalesOrderType = 'OAF' then 'X'
    else ''
end

// utilizando cast
cast(
    case
        when 'TAF' then 'X'
        when 'OAF' then 'X'
        else '' end as abap.char(1) ) as CastVar

```

### Varíaveis de sessão 

Informações da sessão de tempo de execução da CDS. Funciona como o "sy" do abap clássico. 

$session.client
$session.system_date
$session.system_language
$session.user
$session.user_date
$session.user_timezone

## Seleções e Busca de dados

### Select Distinct

Ao aplicar a intrução select distinct, é possível remover registros duplicados da lista de resultados de seleção. A comparação considera todos os campos solicitados.

```java
define view entity Z_View
   as select from t000`{
    abap.char'A' as Campo1

   }

define view entity Z_View2
   as select distinct from t000`{
    abap.char'A' as Campo1

   }
```

Normalmente são usadas como ajudas de pesquisa em CDS. Mas em geral, elas removem a duplicidade em uma CDS.

### Union Definitions

As Union Views combinam e unificam registros de dados em diferentes fontes de dados.

São definidas pela combinação de múltiplos Selects. Itens combinados devem ter o mesmo tipo, podem ser diferentes porém conversíveis. Além disso, anotações de elementos não devem ser propagadas para a union view (uso de @Metadata.ignorePropagatedAnnotations: true).

```java
@Metadata.ignorePropagatedAnnotations: true

define view entity Z_UnionView
  as select from Z_ViewAsDataSourceA
    association [0..1] to Z_ViewAsDataSourceC as _ViewC on 
    $projection.UnionField1 = _ViewC.FieldC1
{
    @EndUserText.label: 'Label of UnionField1'
    key FieldA1 as UnionField1,
    key FieldA2 as UnionField2,
    key FieldA3 as UnionField3,
        _ViewC
}

union select from Z_ViewAsDataSourceB
  association [0..1] to Z_ViewAsDataSourceC as _ViewC on 
  $projection.UnionField1 = _ViewC.FieldC1
{
    key FieldB2 as UnionField1,
    key FieldB1 as UnionField2,
    key ''      as UnionField3,
        _ViewC
}
```


## Atalhos Eclipse 

- SHIFT + F1 = Pretty Printer

- CTRL + CLICK = Transitar para tabelas, composites, views, etc

- CTRL + SPACE = Visualizar campos da tabela automaticamente, funções, possíveis implementações.