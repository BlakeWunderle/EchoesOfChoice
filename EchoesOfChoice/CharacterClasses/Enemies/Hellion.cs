using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Hellion : BaseFighter
    {
        public Hellion(int level = 15)
        {
            Level = level;
            Health = Stat(200, 230, 7, 10, 15);
            MaxHealth = Health;
            PhysicalAttack = Stat(38, 44, 3, 5, 15);
            PhysicalDefense = Stat(26, 32, 2, 3, 15);
            MagicAttack = Stat(30, 36, 2, 4, 15);
            MagicDefense = Stat(22, 28, 2, 3, 15);
            Speed = Stat(32, 38, 2, 4, 15);
            Abilities = new List<Ability>() { new InfernalStrike(), new ShadowStrike(), new Hex() };
            CharacterType = "Hellion";
            Mana = Stat(28, 34, 2, 4, 15);
            MaxMana = Mana;
            CritChance = 24;
            CritDamage = 3;
            DodgeChance = 22;
        }

        public Hellion(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Hellion(this);
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
