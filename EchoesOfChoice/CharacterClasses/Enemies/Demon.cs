using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Demon : BaseFighter
    {
        public Demon(int level = 14)
        {
            Level = level;
            Health = Stat(300, 340, 8, 12, 14);
            MaxHealth = Health;
            PhysicalAttack = Stat(20, 26, 1, 2, 14);
            PhysicalDefense = Stat(22, 28, 2, 3, 14);
            MagicAttack = Stat(52, 60, 4, 6, 14);
            MagicDefense = Stat(28, 34, 2, 3, 14);
            Speed = Stat(30, 36, 2, 3, 14);
            Abilities = new List<Ability>() { new Brimstone(), new InfernalStrike(), new Dread() };
            CharacterType = "Demon";
            Mana = Stat(42, 50, 3, 5, 14);
            MaxMana = Mana;
            CritChance = 22;
            CritDamage = 3;
            DodgeChance = 28;
        }

        public Demon(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Demon(this);
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
