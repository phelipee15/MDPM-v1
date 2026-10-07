# MDPM v1

Resource para **Multi Theft Auto: San Andreas (MTA:SA)** que adiciona um painel de música para veículos. A música é reproduzida como áudio 3D e pode ser acompanhada por efeitos visuais nos alto-falantes e no veículo.

## Recursos

- Reproduz uma URL de áudio no veículo ocupado pelo jogador.
- Ajusta o volume e a distância de propagação do som.
- Exibe efeitos de alto-falante e estroboscópio sincronizados com as frequências da música.
- Permite abrir o painel por tecla ou comando.
- Inclui textos em português, inglês, espanhol e alemão.

## Requisitos

- Servidor MTA:SA **1.5.6-9.18728 ou superior**.
- O resource `[ss]notify` para as notificações padrão. Se não utilizar esse resource, configure a função `config.notify` em `scripts/config.lua` para usar o sistema de notificações do seu servidor.
- Uma URL de áudio compatível com a reprodução de som do MTA:SA.

## Instalação

1. Baixe ou clone este repositório.
2. Coloque a pasta do projeto em `mods/deathmatch/resources/` no servidor. Você pode renomear a pasta, por exemplo, para `mdpm`.
3. Confira a integração de notificações em `scripts/config.lua`. O padrão chama exports do resource `[ss]notify`.
4. Ajuste as opções no mesmo arquivo, se necessário.
5. No console do servidor, inicie o resource:

   ```text
   start mdpm
   ```

   Substitua `mdpm` pelo nome que você deu à pasta.

## Como usar

- Entre em um veículo como motorista ou passageiro dianteiro.
- Pressione **F7** ou digite **/mdpm** para abrir ou fechar o painel.
- Informe uma URL de áudio no campo **URL** e clique em **Tocar**.
- Informe a distância desejada em **Distância**. O valor padrão é 80 e o intervalo permitido é de 10 a 100.
- Use o controle deslizante para alterar o volume.
- Clique em **Parar** para encerrar a música.
- Desmarque **MDPM** para desativar ou marque para reativar os efeitos visuais.

Também é possível iniciar uma música pelo chat usando:

```text
/setradio URL_DO_AUDIO
```

A música e os efeitos são processados pelos clientes próximos ao veículo. O resultado depende da disponibilidade e compatibilidade da URL fornecida.

## Configuração

As opções principais estão em `scripts/config.lua`:

| Opção | Padrão | Descrição |
| --- | --- | --- |
| `config.main.mdpm` | `true` | Inicia os efeitos MDPM ativados. |
| `config.main.cmd` | `"mdpm"` | Comando que abre ou fecha o painel. |
| `config.main.bind` | `"F7"` | Tecla que abre ou fecha o painel. |
| `config.main.language` | `"en"` | Idioma inicial. Use `"pt-BR"`, `"en"`, `"es"` ou `"de"`. |
| `config.options.distance.default` | `80` | Distância padrão do áudio. |
| `config.options.distance.limit` | `{10, 100}` | Distância mínima e máxima permitidas. |
| `config.options.texture` | `"centro"` | Textura usada no efeito dos alto-falantes. |
| `config.options.strobo` | `"rgb"` | Textura usada no efeito estroboscópico. |

A função `config.color` define a cor do painel em RGBA. A tabela `frequencies` associa modelos de objetos a faixas de frequência; os modelos não listados usam a faixa média. A opção `config.dummys` define quais partes do veículo recebem a animação.

## Estrutura

- `meta.xml`: registra scripts, arquivos e versão mínima do MTA:SA.
- `scripts/config.lua`: configurações, notificações e traduções.
- `scripts/main_c.lua`: efeitos visuais e processamento de áudio no cliente.
- `scripts/main_s.lua`: inicialização do servidor.
- `scripts/painel_c.lua`: interface do painel.
- `scripts/setradio_c.lua` e `scripts/setradio_s.lua`: reprodução e controle da rádio.
- `scripts/utils_c.lua` e `scripts/editbox.lua`: funções auxiliares da interface.
- `files/`: imagens, fonte e shaders usados pelo resource. A fonte Inter tem licença própria, incluída em `files/fontes/OFL.txt`.

## Créditos

- **Designer:** William
- **Desenvolvedor:** Phelipe Melo Matos

[Vídeo de apresentação](https://www.youtube.com/watch?v=-4AvA8bPvJk) · [Source Scripts](https://sourcescripts.com.br) · [Discord](https://discord.com/invite/YCsJuJBZu5)

## Licença

O código do projeto está sob a licença MIT. Você pode usar, copiar, modificar, distribuir e comercializar o código, desde que mantenha o aviso de copyright e o texto da licença nas cópias ou partes substanciais do projeto. Consulte [LICENSE](LICENSE).

A fonte Inter incluída no resource é um componente de terceiros sob a SIL Open Font License 1.1 (OFL). Os termos e créditos dessa fonte estão em `files/fontes/OFL.txt`; a licença MIT deste projeto não substitui a licença da fonte.


