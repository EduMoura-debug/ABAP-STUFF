# AGENTS.md — Projeto SAP CAP (Node.js)

Você é um assistente de desenvolvimento em um projeto SAP CAP (Cloud Application
Programming Model) em **Node.js**. Público: desenvolvedores ABAP aprendendo CAP.
Responda e comente código em português (Brasil).

## Regras de ouro (NUNCA violar)

1. NUNCA gere código CAP Java. Este projeto é CAP Node.js.
2. NUNCA invente annotations, APIs ou opções de CLI. Use SOMENTE o que está
   neste documento. Se precisar de algo fora daqui, DIGA que não tem certeza
   e sugira consultar https://cap.cloud.sap/docs — não chute.
3. Antes de criar/alterar qualquer CDS, LEIA os arquivos .cds existentes no
   projeto para entender o modelo atual. Nunca modele "de memória".
4. Uma etapa por vez. Não crie arquivos que não foram pedidos. Mostre o diff
   e explique o que fez em 2-3 linhas.
5. Lógica de negócio NUNCA vai em arquivo .cds — vai em handler .js.

## Estrutura do projeto

- `db/` — modelo de dados (.cds) e mock data (`db/data/*.csv`)
- `srv/` — definições de serviço (.cds) e handlers (.js)
- `app/` — UI (annotations Fiori, apps UI5)
- `package.json` — dependências e config `cds`

## Modelagem CDS (db/schema.cds)

Padrão a seguir:

    namespace my.app;
    using { cuid, managed, sap.common.CodeList } from '@sap/cds/common';

    entity Orders : cuid, managed {
      title       : String(100);
      description : String;
      status      : String enum { open; in_progress; closed; } default 'open';
      priority    : Integer;
      dueDate     : Date;
      equipment   : Association to Equipments;
      technician  : Association to Technicians;
      items       : Composition of many OrderItems on items.parent = $self;
    }

    entity OrderItems : cuid {
      parent   : Association to Orders;
      note     : String;
    }

    entity Equipments : cuid {
      name         : String(80);
      serialNumber : String(40);
      category     : Association to Categories;
    }

    entity Technicians : cuid {
      name  : String(80);
      email : String;
    }

    entity Categories : CodeList {
      key code : String(10);
    }

Regras:

- Entidades em PascalCase plural; elementos em camelCase.
- `cuid` gera key UUID; `managed` gera createdAt/createdBy/modifiedAt/modifiedBy.
  NÃO declare esses campos manualmente.
- Tipos válidos: UUID, Boolean, Integer, Int16/32/64, Decimal(p,s), Double,
  Date, Time, DateTime, Timestamp, String(n), LargeString, Binary, LargeBinary.
- Associação to-one: `Association to X`. To-many: `Association to many X on ...`.
  Composição (pai-filho, delete em cascata): `Composition of many X on x.parent = $self`.
- Code lists: herdar de `sap.common.CodeList` e declarar `key code`.
  (CodeList já traz name e descr — não redeclare.)

## Mock data (db/data/*.csv)

- Nome do arquivo: `<namespace>-<Entidade>.csv` → ex.: `my.app-Orders.csv`
  (namespace com pontos, hífen antes do nome da entidade).
- Header = nomes exatos dos elementos, separados por vírgula ou ponto-e-vírgula.
- Key cuid: coluna `ID` com UUIDs válidos (formato 8-4-4-4-12).
- Associação to-one: coluna `<nome>_ID` → ex.: `technician_ID`, e o valor deve
  existir no CSV da entidade alvo.
- Code list: coluna da associação é `<nome>_code`.
- Campos managed NÃO vão no CSV.

Exemplo `db/data/my.app-Orders.csv`:

    ID,title,status,priority,equipment_ID,technician_ID
    a1e0...,Troca de motor,open,4,b2f1...,c3a2...

## Serviços (srv/service.cds)

    using { my.app as db } from '../db/schema';

    service MainService @(path: '/main') {
      entity Orders      as projection on db.Orders
        actions { action close(); };
      entity Equipments  as projection on db.Equipments;
      @readonly entity Categories as projection on db.Categories;
    }

- Serviço expõe PROJEÇÕES, nunca a entidade do db direto sem projection.
- `@readonly` para dados de referência.
- Actions de instância: dentro de `actions { }` na entidade.
- Action/function de serviço: `action doSomething(param: String) returns String;`
- O CAP serve OData V4 automaticamente. NÃO gere código de CRUD — já existe.

## Validações declarativas (preferir antes de handler)

Annotations válidas: `@mandatory`, `@assert.unique`, `@assert.integrity`,
`@assert.target`, `@assert.range: [min, max]`, `@assert.format: 'regex'`,
`@readonly`, `@insertonly`.
Enum já valida valores automaticamente. NÃO existem outras @assert.* — não invente.

## Handlers (srv/service.js — mesmo nome do .cds)

    const cds = require('@sap/cds')

    module.exports = class MainService extends cds.ApplicationService {
      init() {
        const { Orders } = this.entities

        this.before('CREATE', Orders, (req) => {
          if (!req.data.title) req.reject(400, 'Título é obrigatório')
        })

        this.after('READ', Orders, (orders) => {
          for (const o of orders) if (o.priority >= 4) o.title = `⚠ ${o.title}`
        })

        this.on('close', Orders, async (req) => {
          const [id] = req.params.map(p => p.ID ?? p)
          await UPDATE(Orders, id).with({ status: 'closed' })
          return req.reply({ status: 'closed' })
        })

        return super.init()
      }
    }

- Eventos: `before` (validar/enriquecer), `on` (implementar/substituir),
  `after` (pós-processar resultado).
- Erros: `req.reject(código, 'mensagem')` ou `req.error(...)` (acumula).
- Queries com cds.ql: `SELECT.from(X).where({...})`, `INSERT.into(X).entries([...])`,
  `UPDATE(X, id).with({...})`, `DELETE.from(X).where({...})` — sempre com await.
- NÃO use callbacks de banco, ORM externo nem SQL cru.

## Annotations de UI Fiori (app/annotations.cds)

    using MainService from '../srv/service';

    annotate MainService.Orders with @(UI: {
      HeaderInfo: {
        TypeName: 'Ordem', TypeNamePlural: 'Ordens',
        Title: { Value: title }
      },
      SelectionFields: [ status, priority ],
      LineItem: [
        { Value: title, Label: 'Título' },
        { Value: status, Label: 'Status' },
        { Value: priority, Label: 'Prioridade' },
        { Value: technician.name, Label: 'Técnico' }
      ]
    });

Vocabulário @UI que você PODE usar: HeaderInfo, SelectionFields, LineItem,
FieldGroup, Facets, Identification. Fora disso, não invente termo de UI.

## CLI (comandos válidos)

- `cds init <nome>` · `cds watch` · `cds add hana,mta,xsuaa --for production`
- `cds compile db/schema.cds` (validar sintaxe) · `cds serve`
- Deploy CF: `mbt build` → `cf deploy mta_archives/<nome>.mtar`
- NÃO existem: `cds generate app`, `cds create entity`, `cds add fiori-app`.

## Erros comuns a EVITAR (alucinações conhecidas)

- Inventar annotations (@Core.*, @Common.* fora do documentado) — se não está
  neste arquivo, pergunte antes.
- Misturar sintaxe CAP Java (@Autowired, EventHandler classes) em projeto Node.
- Nomear CSV errado (underscore no namespace, sem hífen) — dado não carrega.
- Declarar createdAt/ID manualmente junto com cuid/managed — conflito.
- Esquecer `await` em queries cds.ql.
- Colocar `service` dentro de db/schema.cds — serviço mora em srv/.

## Fluxo de trabalho

1. Ler os .cds existentes antes de qualquer mudança
2. Propor a mudança e mostrar o diff
3. Validar com `cds compile` mentalmente (sintaxe deste documento)
4. Após aplicar, dizer como testar (URL do cds watch, exemplo de request)

## Documentação oficial (única fonte confiável além deste arquivo)

- Modelagem: https://cap.cloud.sap/docs/guides/domain/
- Serviços: https://cap.cloud.sap/docs/guides/services/providing-services
- CDL (sintaxe CDS): https://cap.cloud.sap/docs/cds/cdl
- Node.js API: https://cap.cloud.sap/docs/node.js/
- Fiori: https://cap.cloud.sap/docs/guides/uis/fiori