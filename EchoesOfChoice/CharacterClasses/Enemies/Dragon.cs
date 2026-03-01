using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Dragon : BaseFighter
    {
        public Dragon(int level = 15)
        {
            Level = level;
            Health = Stat(340, 380, 10, 14, 15);
            MaxHealth = Health;
            PhysicalAttack = Stat(30, 36, 2, 3, 15);
            PhysicalDefense = Stat(30, 36, 2, 4, 15);
            MagicAttack = Stat(44, 52, 3, 5, 15);
            MagicDefense = Stat(26, 32, 2, 3, 15);
            Speed = Stat(30, 36, 2, 3, 15);
            Abilities = new List<Ability>() { new DragonBreath(), new TailStrike(), new Roar() };
            CharacterType = "Dragon";
            Mana = Stat(36, 42, 3, 5, 15);
            MaxMana = Mana;
            CritChance = 30;
            CritDamage = 4;
            DodgeChance = 20;
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
