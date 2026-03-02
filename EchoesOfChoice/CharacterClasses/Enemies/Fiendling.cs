using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Fiendling : BaseFighter
    {
        public Fiendling(int level = 17)
        {
            Level = level;
            Health = Stat(240, 280, 7, 10, 17);
            MaxHealth = Health;
            PhysicalAttack = Stat(20, 26, 1, 3, 17);
            PhysicalDefense = Stat(24, 30, 2, 3, 17);
            MagicAttack = Stat(68, 78, 5, 7, 17);
            MagicDefense = Stat(32, 38, 2, 4, 17);
            Speed = Stat(38, 44, 3, 5, 17);
            Abilities = new List<Ability>() { new Brimstone(), new Dread(), new Hex() };
            CharacterType = "Fiendling";
            Mana = Stat(40, 48, 3, 5, 17);
            MaxMana = Mana;
            CritChance = 25;
            CritDamage = 4;
            DodgeChance = 21;
        }

        public Fiendling(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Fiendling(this);
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
