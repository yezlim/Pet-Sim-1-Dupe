--[[
Made by Exoverts, 
Obfuscated so you skids cant skid it lololol
]]--

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			repeatNext = StrToNumber(Sub(byte, 1, 1));
			return "";
		else
			local FlatIdent_7126A = 0;
			local a;
			while true do
				if (FlatIdent_7126A == 0) then
					a = Char(StrToNumber(byte, 16));
					if repeatNext then
						local FlatIdent_12703 = 0;
						local b;
						while true do
							if (FlatIdent_12703 == 0) then
								b = Rep(a, repeatNext);
								repeatNext = nil;
								FlatIdent_12703 = 1;
							end
							if (FlatIdent_12703 == 1) then
								return b;
							end
						end
					else
						return a;
					end
					break;
				end
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local FlatIdent_475BC = 0;
			local Plc;
			while true do
				if (FlatIdent_475BC == 0) then
					Plc = 2 ^ (Start - 1);
					return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
				end
			end
		end
	end
	local function gBits8()
		local FlatIdent_60EA1 = 0;
		local a;
		while true do
			if (FlatIdent_60EA1 == 1) then
				return a;
			end
			if (FlatIdent_60EA1 == 0) then
				a = Byte(ByteString, DIP, DIP);
				DIP = DIP + 1;
				FlatIdent_60EA1 = 1;
			end
		end
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local FlatIdent_8F047 = 0;
		local a;
		local b;
		local c;
		local d;
		while true do
			if (FlatIdent_8F047 == 0) then
				a, b, c, d = Byte(ByteString, DIP, DIP + 3);
				DIP = DIP + 4;
				FlatIdent_8F047 = 1;
			end
			if (FlatIdent_8F047 == 1) then
				return (d * 16777216) + (c * 65536) + (b * 256) + a;
			end
		end
	end
	local function gFloat()
		local FlatIdent_6FA1 = 0;
		local Left;
		local Right;
		local IsNormal;
		local Mantissa;
		local Exponent;
		local Sign;
		while true do
			if (FlatIdent_6FA1 == 1) then
				IsNormal = 1;
				Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
				FlatIdent_6FA1 = 2;
			end
			if (FlatIdent_6FA1 == 2) then
				Exponent = gBit(Right, 21, 31);
				Sign = ((gBit(Right, 32) == 1) and -1) or 1;
				FlatIdent_6FA1 = 3;
			end
			if (0 == FlatIdent_6FA1) then
				Left = gBits32();
				Right = gBits32();
				FlatIdent_6FA1 = 1;
			end
			if (FlatIdent_6FA1 == 3) then
				if (Exponent == 0) then
					if (Mantissa == 0) then
						return Sign * 0;
					else
						local FlatIdent_455BF = 0;
						while true do
							if (FlatIdent_455BF == 0) then
								Exponent = 1;
								IsNormal = 0;
								break;
							end
						end
					end
				elseif (Exponent == 2047) then
					return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
				end
				return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
			end
		end
	end
	local function gString(Len)
		local FlatIdent_2FD19 = 0;
		local Str;
		local FStr;
		while true do
			if (FlatIdent_2FD19 == 2) then
				FStr = {};
				for Idx = 1, #Str do
					FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
				end
				FlatIdent_2FD19 = 3;
			end
			if (FlatIdent_2FD19 == 1) then
				Str = Sub(ByteString, DIP, (DIP + Len) - 1);
				DIP = DIP + Len;
				FlatIdent_2FD19 = 2;
			end
			if (FlatIdent_2FD19 == 0) then
				Str = nil;
				if not Len then
					local FlatIdent_33EA4 = 0;
					while true do
						if (FlatIdent_33EA4 == 0) then
							Len = gBits32();
							if (Len == 0) then
								return "";
							end
							break;
						end
					end
				end
				FlatIdent_2FD19 = 1;
			end
			if (FlatIdent_2FD19 == 3) then
				return Concat(FStr);
			end
		end
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local Type = gBits8();
			local Cons;
			if (Type == 1) then
				Cons = gBits8() ~= 0;
			elseif (Type == 2) then
				Cons = gFloat();
			elseif (Type == 3) then
				Cons = gString();
			end
			Consts[Idx] = Cons;
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local FlatIdent_25DF3 = 0;
				local Type;
				local Mask;
				local Inst;
				while true do
					if (FlatIdent_25DF3 == 2) then
						if (gBit(Mask, 1, 1) == 1) then
							Inst[2] = Consts[Inst[2]];
						end
						if (gBit(Mask, 2, 2) == 1) then
							Inst[3] = Consts[Inst[3]];
						end
						FlatIdent_25DF3 = 3;
					end
					if (FlatIdent_25DF3 == 0) then
						Type = gBit(Descriptor, 2, 3);
						Mask = gBit(Descriptor, 4, 6);
						FlatIdent_25DF3 = 1;
					end
					if (FlatIdent_25DF3 == 3) then
						if (gBit(Mask, 3, 3) == 1) then
							Inst[4] = Consts[Inst[4]];
						end
						Instrs[Idx] = Inst;
						break;
					end
					if (FlatIdent_25DF3 == 1) then
						Inst = {gBits16(),gBits16(),nil,nil};
						if (Type == 0) then
							local FlatIdent_39764 = 0;
							while true do
								if (FlatIdent_39764 == 0) then
									Inst[3] = gBits16();
									Inst[4] = gBits16();
									break;
								end
							end
						elseif (Type == 1) then
							Inst[3] = gBits32();
						elseif (Type == 2) then
							Inst[3] = gBits32() - (2 ^ 16);
						elseif (Type == 3) then
							Inst[3] = gBits32() - (2 ^ 16);
							Inst[4] = gBits16();
						end
						FlatIdent_25DF3 = 2;
					end
				end
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 19) then
					if (Enum <= 9) then
						if (Enum <= 4) then
							if (Enum <= 1) then
								if (Enum == 0) then
									local FlatIdent_494DF = 0;
									local A;
									local Results;
									local Edx;
									while true do
										if (FlatIdent_494DF == 0) then
											A = Inst[2];
											Results = {Stk[A](Stk[A + 1])};
											FlatIdent_494DF = 1;
										end
										if (FlatIdent_494DF == 1) then
											Edx = 0;
											for Idx = A, Inst[4] do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											break;
										end
									end
								else
									local B;
									local T;
									local A;
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									T = Stk[A];
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
								end
							elseif (Enum <= 2) then
								Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
							elseif (Enum == 3) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							else
								local Edx;
								local Results, Limit;
								local B;
								local A;
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Upvalues[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
							end
						elseif (Enum <= 6) then
							if (Enum > 5) then
								VIP = Inst[3];
							elseif Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 7) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						elseif (Enum == 8) then
							local FlatIdent_189F0 = 0;
							local A;
							local Results;
							local Limit;
							local Edx;
							while true do
								if (FlatIdent_189F0 == 0) then
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									FlatIdent_189F0 = 1;
								end
								if (FlatIdent_189F0 == 1) then
									Top = (Limit + A) - 1;
									Edx = 0;
									FlatIdent_189F0 = 2;
								end
								if (FlatIdent_189F0 == 2) then
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									break;
								end
							end
						else
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum <= 14) then
						if (Enum <= 11) then
							if (Enum > 10) then
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							else
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 12) then
							Stk[Inst[2]] = Inst[3] ~= 0;
						elseif (Enum == 13) then
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
						else
							local B;
							local A;
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
					elseif (Enum <= 16) then
						if (Enum > 15) then
							Stk[Inst[2]] = Upvalues[Inst[3]];
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
					elseif (Enum <= 17) then
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum > 18) then
						Stk[Inst[2]] = Stk[Inst[3]];
					elseif (Inst[2] == Stk[Inst[4]]) then
						VIP = VIP + 1;
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 29) then
					if (Enum <= 24) then
						if (Enum <= 21) then
							if (Enum > 20) then
								Stk[Inst[2]] = Inst[3];
							else
								local NewProto = Proto[Inst[3]];
								local NewUvals;
								local Indexes = {};
								NewUvals = Setmetatable({}, {__index=function(_, Key)
									local Val = Indexes[Key];
									return Val[1][Val[2]];
								end,__newindex=function(_, Key, Value)
									local FlatIdent_207CC = 0;
									local Val;
									while true do
										if (FlatIdent_207CC == 0) then
											Val = Indexes[Key];
											Val[1][Val[2]] = Value;
											break;
										end
									end
								end});
								for Idx = 1, Inst[4] do
									VIP = VIP + 1;
									local Mvm = Instr[VIP];
									if (Mvm[1] == 19) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 22) then
							local FlatIdent_6DC53 = 0;
							local A;
							while true do
								if (0 == FlatIdent_6DC53) then
									A = Inst[2];
									Stk[A](Stk[A + 1]);
									break;
								end
							end
						elseif (Enum == 23) then
							local FlatIdent_61EE = 0;
							local A;
							local T;
							while true do
								if (0 == FlatIdent_61EE) then
									A = Inst[2];
									T = Stk[A];
									FlatIdent_61EE = 1;
								end
								if (1 == FlatIdent_61EE) then
									for Idx = A + 1, Inst[3] do
										Insert(T, Stk[Idx]);
									end
									break;
								end
							end
						else
							local A = Inst[2];
							local C = Inst[4];
							local CB = A + 2;
							local Result = {Stk[A](Stk[A + 1], Stk[CB])};
							for Idx = 1, C do
								Stk[CB + Idx] = Result[Idx];
							end
							local R = Result[1];
							if R then
								Stk[CB] = R;
								VIP = Inst[3];
							else
								VIP = VIP + 1;
							end
						end
					elseif (Enum <= 26) then
						if (Enum > 25) then
							local A = Inst[2];
							local Cls = {};
							for Idx = 1, #Lupvals do
								local List = Lupvals[Idx];
								for Idz = 0, #List do
									local FlatIdent_6C033 = 0;
									local Upv;
									local NStk;
									local DIP;
									while true do
										if (0 == FlatIdent_6C033) then
											Upv = List[Idz];
											NStk = Upv[1];
											FlatIdent_6C033 = 1;
										end
										if (FlatIdent_6C033 == 1) then
											DIP = Upv[2];
											if ((NStk == Stk) and (DIP >= A)) then
												Cls[DIP] = NStk[DIP];
												Upv[1] = Cls;
											end
											break;
										end
									end
								end
							end
						else
							local B;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 27) then
						do
							return;
						end
					elseif (Enum > 28) then
						if (Stk[Inst[2]] == Stk[Inst[4]]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						local FlatIdent_5998C = 0;
						local A;
						while true do
							if (FlatIdent_5998C == 0) then
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Top));
								break;
							end
						end
					end
				elseif (Enum <= 34) then
					if (Enum <= 31) then
						if (Enum == 30) then
							Stk[Inst[2]] = {};
						else
							local FlatIdent_2388 = 0;
							local A;
							while true do
								if (3 == FlatIdent_2388) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3] ~= 0;
									FlatIdent_2388 = 4;
								end
								if (FlatIdent_2388 == 5) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
									break;
								end
								if (FlatIdent_2388 == 2) then
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									FlatIdent_2388 = 3;
								end
								if (FlatIdent_2388 == 0) then
									A = nil;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									FlatIdent_2388 = 1;
								end
								if (FlatIdent_2388 == 1) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									FlatIdent_2388 = 2;
								end
								if (4 == FlatIdent_2388) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_2388 = 5;
								end
							end
						end
					elseif (Enum <= 32) then
						if (Stk[Inst[2]] == Inst[4]) then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum == 33) then
						local FlatIdent_DFF4 = 0;
						local B;
						local K;
						while true do
							if (FlatIdent_DFF4 == 0) then
								B = Inst[3];
								K = Stk[B];
								FlatIdent_DFF4 = 1;
							end
							if (FlatIdent_DFF4 == 1) then
								for Idx = B + 1, Inst[4] do
									K = K .. Stk[Idx];
								end
								Stk[Inst[2]] = K;
								break;
							end
						end
					else
						local A;
						local K;
						local B;
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						B = Inst[3];
						K = Stk[B];
						for Idx = B + 1, Inst[4] do
							K = K .. Stk[Idx];
						end
						Stk[Inst[2]] = K;
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Upvalues[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						B = Inst[3];
						K = Stk[B];
						for Idx = B + 1, Inst[4] do
							K = K .. Stk[Idx];
						end
						Stk[Inst[2]] = K;
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						VIP = Inst[3];
					end
				elseif (Enum <= 36) then
					if (Enum == 35) then
						local A = Inst[2];
						Stk[A] = Stk[A](Stk[A + 1]);
					else
						local FlatIdent_1B881 = 0;
						local A;
						local B;
						while true do
							if (FlatIdent_1B881 == 1) then
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								break;
							end
							if (FlatIdent_1B881 == 0) then
								A = Inst[2];
								B = Stk[Inst[3]];
								FlatIdent_1B881 = 1;
							end
						end
					end
				elseif (Enum <= 37) then
					local FlatIdent_1FC27 = 0;
					local A;
					local T;
					local B;
					while true do
						if (FlatIdent_1FC27 == 1) then
							B = Inst[3];
							for Idx = 1, B do
								T[Idx] = Stk[A + Idx];
							end
							break;
						end
						if (FlatIdent_1FC27 == 0) then
							A = Inst[2];
							T = Stk[A];
							FlatIdent_1FC27 = 1;
						end
					end
				elseif (Enum == 38) then
					local FlatIdent_20FE3 = 0;
					local K;
					local B;
					local A;
					while true do
						if (FlatIdent_20FE3 == 0) then
							K = nil;
							B = nil;
							A = nil;
							FlatIdent_20FE3 = 1;
						end
						if (8 == FlatIdent_20FE3) then
							for Idx = B + 1, Inst[4] do
								K = K .. Stk[Idx];
							end
							Stk[Inst[2]] = K;
							VIP = VIP + 1;
							FlatIdent_20FE3 = 9;
						end
						if (FlatIdent_20FE3 == 7) then
							Inst = Instr[VIP];
							B = Inst[3];
							K = Stk[B];
							FlatIdent_20FE3 = 8;
						end
						if (FlatIdent_20FE3 == 5) then
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							FlatIdent_20FE3 = 6;
						end
						if (2 == FlatIdent_20FE3) then
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							FlatIdent_20FE3 = 3;
						end
						if (FlatIdent_20FE3 == 3) then
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							FlatIdent_20FE3 = 4;
						end
						if (FlatIdent_20FE3 == 4) then
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							FlatIdent_20FE3 = 5;
						end
						if (FlatIdent_20FE3 == 1) then
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							FlatIdent_20FE3 = 2;
						end
						if (6 == FlatIdent_20FE3) then
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							FlatIdent_20FE3 = 7;
						end
						if (FlatIdent_20FE3 == 9) then
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Stk[A + 1]);
							break;
						end
					end
				else
					local FlatIdent_44265 = 0;
					local A;
					while true do
						if (FlatIdent_44265 == 0) then
							A = nil;
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							FlatIdent_44265 = 1;
						end
						if (FlatIdent_44265 == 2) then
							VIP = VIP + 1;
							Inst = Instr[VIP];
							for Idx = Inst[2], Inst[3] do
								Stk[Idx] = nil;
							end
							FlatIdent_44265 = 3;
						end
						if (FlatIdent_44265 == 1) then
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A](Stk[A + 1]);
							FlatIdent_44265 = 2;
						end
						if (FlatIdent_44265 == 4) then
							VIP = VIP + 1;
							Inst = Instr[VIP];
							VIP = Inst[3];
							break;
						end
						if (FlatIdent_44265 == 3) then
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							FlatIdent_44265 = 4;
						end
					end
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!223O00028O00026O00F03F027O0040026O00084003053O007072696E7403153O00436F6D706C657465205374617473205461626C653A03053O00706169727303083O00746F6E756D62657203023O006964030B3O00746172676574506574494403093O004475706C696361746503053O007063612O6C03343O00506574206475706C69636174696F6E20726571756573742073656E742073752O63652O7366752O6C7920666F722070657420494403043O007761726E03263O00452O726F722073656E64696E6720706574206475706C69636174696F6E20726571756573743A03133O0056616C69642070657420494420666F756E643A03093O00496E76656E746F727903043O005065747303043O007479706503053O007461626C65030E3O004E6F20706574207769746820494403203O00666F756E6420696E20616E7920706C61796572277320696E76656E746F72792E03223O005374617473205461626C652072656365697665642073752O63652O7366752O6C792E032A3O004661696C656420746F207265747269657665207374617473207461626C652066726F6D2073657276657203053O0064656C6179026O004E4003043O0067616D65030A3O004765745365727669636503093O00576F726B7370616365030C3O0057616974466F724368696C6403093O002O5F52454D4F54455303043O00436F7265030F3O00476574204F74686572205374617473030C3O00496E766F6B6553657276657200CB3O0012153O00014O000A000100023O0026203O00AD000100020004063O00AD0001000605000200A500013O0004063O00A50001001215000300014O000A000400053O0026200003000F000100030004063O000F00012O0013000600044O0013000700024O00160006000200012O000C00055O001215000300043O00262000030017000100020004063O0017000100061400043O000100012O00133O00043O00120F000600053O001215000700064O0016000600020001001215000300033O0026200003009B000100040004063O009B000100120F000600074O0013000700026O0006000200080004063O00910001001215000B00014O000A000C000C3O002620000B0065000100020004063O00650001000605000C009100013O0004063O0091000100120F000D00074O0013000E000C6O000D0002000F0004063O00620001001215001200014O000A001300133O00262000120029000100010004063O0029000100120F001400083O0020030015001100092O00230014000200022O0013001300143O0006050013006200013O0004063O0062000100120F0014000A3O00061D00130062000100140004063O00620001001215001400014O000A001500173O00262000140048000100020004063O004800012O001E001800014O0001001900016O001A00023O00122O001B000B6O001C00136O001A000200012O00250019000100012O00250018000100012O0013001500183O00120F0018000C3O00061400190001000100012O00133O00156O0018000200192O0013001700194O0013001600183O001215001400033O00262000140056000100030004063O005600010006050016005100013O0004063O0051000100120F001800053O0012150019000D3O00120F001A000A4O00090018001A00010004063O005F000100120F0018000E3O0012150019000F4O0013001A00174O00090018001A00010004063O005F000100262000140036000100010004063O0036000100120F001800053O00121F001900106O001A00136O0018001A00014O000500013O00122O001400023O00044O003600012O001A00145O0004063O006200010004063O00290001000618000D0027000100020004063O002700010004063O00910001002620000B001F000100010004063O001F0001001215000D00013O002620000D006C000100020004063O006C0001001215000B00023O0004063O001F0001002620000D0068000100010004063O006800012O000A000C000C3O002003000E000A0011000605000E007900013O0004063O00790001002003000E000A0011002003000E000E0012000605000E007900013O0004063O00790001002003000E000A0011002003000C000E00120004063O008E0001002003000E000A0012000605000E007E00013O0004063O007E0001002003000C000A00120004063O008E000100120F000E00074O0013000F000A6O000E000200100004063O008C000100120F001300134O0013001400124O00230013000200020026200013008C000100140004063O008C00010020030013001200120006050013008C00013O0004063O008C0001002003000C001200120004063O008E0001000618000E0082000100020004063O00820001001215000D00023O0004063O006800010004063O001F00010006180006001D000100020004063O001D0001000611000500A3000100010004063O00A3000100120F0006000E3O00120B000700153O00122O0008000A3O00122O000900166O00060009000100044O00A3000100262000030008000100010004063O0008000100120F000600053O001227000700176O0006000200014O000400043O00122O000300023O00044O000800012O001A00035O0004063O00A8000100120F0003000E3O001215000400184O001600030002000100120F000300193O0012150004001A3O002O02000500024O00090003000500010004063O00CA00010026203O0002000100010004063O00020001001215000300013O002620000300C4000100010004063O00C4000100120F0004001B3O00200D00040004001C00122O0006001D6O00040006000200202O00040004001E00122O0006001F6O00040006000200202O00040004001E00122O000600206O00040006000200202O00040004001E001215000600214O00190004000600024O000100043O00202O0004000100224O0004000200024O000200043O00122O000300023O000E12000200B0000100030004063O00B000010012153O00023O0004063O000200010004063O00B000010004063O000200012O001B3O00013O00033O000A3O00028O00034O0003053O00706169727303043O007479706503053O007461626C6503053O007072696E7403013O003A03023O002O2003023O003A2003083O00746F737472696E6702353O001215000200014O000A000300033O00262000020002000100010004063O00020001001215000300013O00262000030005000100010004063O000500010006110001000A000100010004063O000A0001001215000100023O00120F000400034O001300058O0004000200060004063O002E000100120F000900044O0013000A00084O002300090002000200262000090025000100050004063O00250001001215000900013O00262000090014000100010004063O0014000100120F000A00064O0022000B00016O000C00073O00122O000D00076O000B000B000D4O000A000200014O000A8O000B00086O000C00013O00122O000D00086O000C000C000D4O000A000C000100044O002E00010004063O001400010004063O002E000100120F000900064O0026000A00016O000B00073O00122O000C00093O00122O000D000A6O000E00086O000D000200024O000A000A000D4O0009000200010006180004000E000100020004063O000E00010004063O003400010004063O000500010004063O003400010004063O000200012O001B3O00017O00093O0003043O0067616D65030A3O004765745365727669636503093O00576F726B7370616365030C3O0057616974466F724368696C6403093O002O5F52454D4F54455303043O0047616D6503043O0050657473030A3O004669726553657276657203063O00756E7061636B00133O0012043O00013O00206O000200122O000200038O0002000200206O000400122O000200058O0002000200206O000400122O000200068O0002000200206O000400122O000200078O0002000200206O000800122O000200096O00038O000200039O0000016O00017O000C3O0003043O006D61746803063O0072616E646F6D026O00F03F026O004940026O00144003063O00737472696E6703063O00666F726D617403573O004475706C69636174696F6E2068617320622O656E20696E697469617465642C2069742077692O6C2074616B65202564206D696E757465732C206368616E6365206F66206475706C69636174696F6E2069732025642O252E03043O0067616D6503073O00506C6179657273030B3O004C6F63616C506C6179657203043O004B69636B00173O00120E3O00013O00206O000200122O000100033O00122O000200048O0002000200122O000100013O00202O00010001000200122O000200033O00122O000300056O00010003000200122O000200063O00202O00020002000700122O000300086O00048O000500016O00020005000200122O000300093O00202O00030003000A00202O00030003000B00202O00030003000C4O000500026O0003000500016O00017O00", GetFEnv(), ...);
