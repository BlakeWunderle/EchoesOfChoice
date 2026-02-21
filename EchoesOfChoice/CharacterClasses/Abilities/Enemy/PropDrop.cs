using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class PropDrop : Ability
    {
        public PropDrop()
        {
            Name = "Prop Drop";
            FlavorText = "Something impossibly heavy falls from nowhere.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
