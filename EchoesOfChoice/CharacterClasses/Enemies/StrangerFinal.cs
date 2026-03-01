using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class StrangerFinal : BaseFighter
    {
        public StrangerFinal(int level = 18)
        {
            Level = level;
            Health = Stat(600, 680, 18, 25, 18);
            MaxHealth = Health;
            PhysicalAttack = Stat(60, 70, 4, 6, 18);
            PhysicalDefense = Stat(38, 44, 3, 5, 18);
            MagicAttack = Stat(65, 75, 4, 7, 18);
            MagicDefense = Stat(38, 44, 3, 5, 18);
            Speed = Stat(40, 46, 3, 5, 18);
            Abilities = new List<Ability>() { new ShadowBlast(), new Siphon(), new DarkVeil(), new Unmake(), new Corruption() };
            CharacterType = "Stranger";
            Mana = Stat(50, 60, 4, 6, 18);
            MaxMana = Mana;
            CritChance = 30;
            CritDamage = 6;
            DodgeChance = 25;
        }

        public StrangerFinal(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new StrangerFinal(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(10, 15);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
