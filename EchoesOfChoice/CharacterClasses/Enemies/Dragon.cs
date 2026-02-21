using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Dragon : BaseFighter
    {
        public Dragon(int level = 6)
        {
            Level = level;
            Health = Stat(218, 228, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(20, 24, 0, 0, 6);
            PhysicalDefense = Stat(23, 27, 0, 0, 6);
            MagicAttack = Stat(27, 31, 0, 0, 6);
            MagicDefense = Stat(18, 22, 0, 0, 6);
            Speed = Stat(13, 17, 0, 0, 6);
            Abilities = new List<Ability>() { new DragonBreath(), new TailStrike(), new Roar() };
            CharacterType = "Dragon";
            Mana = Stat(29, 34, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 3;
            CritDamage = 2;
            DodgeChance = 2;
        }

        public Dragon(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Dragon(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
