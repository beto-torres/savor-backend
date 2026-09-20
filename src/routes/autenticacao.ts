import { Router } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { config } from "../config.js";
import { pool } from "../database/pool.js";

const esquemaEntrada = z.object({
  cpf: z.string().transform((value) => value.replace(/\D/g, "")).pipe(z.string().length(11)),
  senha: z.string().min(1),
});

export const rotasAutenticacao = Router();

rotasAutenticacao.post("/entrar", async (requisicao, resposta) => {
  const validacao = esquemaEntrada.safeParse(requisicao.body);

  if (!validacao.success) {
    resposta.status(400).json({ erro: "CPF ou senha inválidos." });
    return;
  }

  const resultado = await pool.query<{
    id: string;
    nome: string;
    cpf: string;
    telefone: string;
    email: string;
    senha_hash: string;
    tipo: "administrador" | "cozinha" | "aluno";
    criado_em: Date;
  }>("SELECT id, nome, cpf, telefone, email, senha_hash, tipo, criado_em FROM usuarios WHERE cpf = $1", [validacao.data.cpf]);
  const usuario = resultado.rows[0];

  if (!usuario || !(await bcrypt.compare(validacao.data.senha, usuario.senha_hash))) {
    resposta.status(401).json({ erro: "CPF ou senha inválidos." });
    return;
  }

  const token = jwt.sign({ tipo: usuario.tipo }, config.JWT_SECRET, {
    subject: usuario.id,
    expiresIn: "8h",
  });

  resposta.json({
    token,
    usuario: {
      id: usuario.id,
      nome: usuario.nome,
      cpf: usuario.cpf,
      telefone: usuario.telefone,
      email: usuario.email,
      tipo: usuario.tipo,
      criadoEm: usuario.criado_em,
    },
  });
});
