using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class PlagueCurse : Ability
    {
        public PlagueCurse()
        {
            Name = "Plague Curse";
            FlavorText = "Curse all enemies with a wasting plague.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 5;
            TargetAll = true;
        }
    }
}
