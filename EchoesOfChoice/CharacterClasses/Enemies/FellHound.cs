using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class FellHound : BaseFighter
    {
        public FellHound(int level = 18)
        {
            Level = level;
            Health = Stat(284, 324, 7, 10, 18);
            MaxHealth = Health;
            PhysicalAttack = Stat(24, 30, 1, 3, 18);
            PhysicalDefense = Stat(26, 32, 2, 3, 18);
            MagicAttack = Stat(55, 63, 3, 5, 18);
            MagicDefense = Stat(32, 38, 2, 4, 18);
            Speed = Stat(40, 46, 3, 5, 18);
            Abilities = new List<Ability>() { new ShadowBite(), new HowlOfDread(), new Blight() };
            CharacterType = "Fell Hound";
            Mana = Stat(30, 38, 3, 5, 18);
            MaxMana = Mana;
            CritChance = 22;
            CritDamage = 4;
            DodgeChance = 24;
        }

        public FellHound(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new FellHound(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 2);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
