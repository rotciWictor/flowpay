from PIL import Image

try:
    img = Image.open('assets/images/logoF.png')
    img = img.convert('RGBA')

    w, h = img.size

    # Criando um fundo vazio transparente do mesmo tamanho
    canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))

    # Reduzindo a imagem para 60% do tamanho para criar a margem de segurança (Safe Zone)
    target_w = int(w * 0.6)
    target_h = int(h * 0.6)

    # LANCZOS é o método de melhor qualidade para redimensionamento
    f_resized = img.resize((target_w, target_h), Image.Resampling.LANCZOS)

    # Calculando o centro exato
    offset_x = (w - target_w) // 2
    offset_y = (h - target_h) // 2

    # Colando o "F" menor no centro do fundo vazio
    canvas.paste(f_resized, (offset_x, offset_y), f_resized)

    # Salvando a nova imagem com margem
    canvas.save('assets/images/logoF_padded.png')
    print("Imagem com margem gerada com sucesso!")
except Exception as e:
    print(f"Erro: {e}")
